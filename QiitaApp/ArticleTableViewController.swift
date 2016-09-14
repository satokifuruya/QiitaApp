//
//  ArticleTableViewController.swift
//  QiitaApp
//
//  Created by satoki furuya on 2016/09/13.
//  Copyright © 2016年 satoki furuya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ArticleTableViewController: UITableViewController, UISearchBarDelegate {
    
    var articleArray = [Article]()
    var imageCache = NSCache()
    var searchBar: UISearchBar!
    
    //APIのURL
    let baseUrl: String = "https://qiita.com/api/v2/items"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupRefreshControl()
        getArticles()
        
        //Qiita Apiの利用制限(ユーザー認証させないと60回/h)に引っかからない用
        //getDammyArticles()
    }
    
    
    //ナビゲーションに検索バーを追加
    private func setupSearchBar() {
        if let navigationBarFrame = navigationController?.navigationBar.bounds {
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.delegate = self
            searchBar.placeholder = "検索キーワード"
            searchBar.autocapitalizationType = UITextAutocapitalizationType.None
            searchBar.keyboardType = UIKeyboardType.Default
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            self.searchBar = searchBar
        }
    }
    
    private func setupRefreshControl(){
        self.refreshControl = UIRefreshControl()
        //self.refreshControl?.attributedTitle = NSAttributedString(string: "更新中…")
        self.refreshControl?.addTarget(self, action: #selector(ArticleTableViewController.refreshTable), forControlEvents: UIControlEvents.ValueChanged)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func refreshTable() {
        print("call refresh.")
        getArticles()
        self.refreshControl?.endRefreshing()
    }
    
    
    //検索バーに1文字以上あれば検索
    func getArticles() {
        guard let inputText = searchBar.text else {
            getArticlesWithQuery(nil)
            return
        }
        
        if inputText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
            getArticlesWithQuery(inputText)
        } else {
            getArticlesWithQuery(nil)
        }
    }
    
    // 引数がnilならbaseUrlのまま、引数が入っていたら検索クエリとしてエンコードしたurlで記事を取得
    private func getArticlesWithQuery(query: String?) {
        var requestUrl = baseUrl
        if let _ = query {
            let parameter = ["query": query]
            requestUrl = createRequestUrl(parameter)
        }
        
        Alamofire.request(.GET, requestUrl)
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                self.articleArray.removeAll()
                let json = JSON(object)
                json.forEach { (_, json) in
                    let article = Article()
                    article.title = json["title"].stringValue
                    article.articleUrl = json["url"].stringValue
                    article.userId = json["user"]["id"].stringValue
                    article.iconImageUrl = json["user"]["profile_image_url"].stringValue
                    self.articleArray.append(article)
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
        }
    }
    
    //ダミー用のメソッド()
    func getDammyArticles() {
        self.articleArray.removeAll()
        for i in 1...10 {
            let article = Article()
            article.title = "ダミータイトル \(i)"
            article.articleUrl = "https://www.google.co.jp/"
            article.userId = "ダミーユーザー \(i)"
            article.iconImageUrl = "https://qiita-image-store.s3.amazonaws.com/0/88/profile-images/1473684075"
            self.articleArray.append(article)
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }

    // MARK: - search bar delegate
    //キーボードのsearchボタンがタップされた時に呼び出される
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        getArticles()
        searchBar.resignFirstResponder()
    }
    
    @IBAction func tapSearchBarButton(sender: UIBarButtonItem) {
        getArticles()
        searchBar.resignFirstResponder()
    }
    

    //URL作成処理
    func createRequestUrl(parameter :[String:String?]) -> String {
        var parameterString = ""
        for key in parameter.keys {
            if let value = parameter[key] {
                //既にパラメータが設定されていた場合
                if parameterString.lengthOfBytesUsingEncoding(
                    NSUTF8StringEncoding) > 0 {
                    parameterString += "&"
                }
                
                //値をエンコードする
                if let escapedValue =
                    value!.stringByAddingPercentEncodingWithAllowedCharacters(
                        NSCharacterSet.URLQueryAllowedCharacterSet()) {
                    parameterString += "\(key)=\(escapedValue)"
                }
            }
        }
        let requestUrl = baseUrl + "?" + parameterString
        return requestUrl
    }

    
    // MARK: - Table view data source
    //テーブルセルの取得処理
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("articleCell", forIndexPath: indexPath) as! ArticleTableViewCell
        let article = articleArray[indexPath.row]
        cell.titleLabel.text = article.title
        cell.userIdLabel.text = article.userId
        
        cell.articleUrl = article.articleUrl
        
        //画像処理↓
        //画像がまだ設定されていない場合に処理を行なう
        let iconImageUrl = article.iconImageUrl
        //キャッシュの画像を取り出す
        if let cacheImage = imageCache.objectForKey(iconImageUrl) as? UIImage {
            //キャッシュの画像を設定
            cell.iconImage.image = cacheImage
        } else {
            //画像のダウンロード処理
            let session = NSURLSession.sharedSession()
            if let url = NSURL(string: iconImageUrl){
                let request = NSURLRequest(URL: url)
                let task = session.dataTaskWithRequest(
                    request, completionHandler: {
                        (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                        if let data = data {
                            if let image = UIImage(data: data) {
                                //ダウンロードした画像をキャッシュに登録しておく
                                self.imageCache.setObject(image, forKey: iconImageUrl)
                                //画像はメインスレッド上で設定する
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    cell.iconImage.image = image
                                })
                            }
                        }
                })
                //画像の読み込み処理開始
                task.resume()
            }
        
        }
        //画像ここまで
        return cell
    }
    
    //セクションの数取得処理
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //アイテムの数取得処理
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleArray.count
    }
    
    
    //商品をタップして次の画面に遷移する前の処理
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? ArticleTableViewCell {
            if let articleWebViewController = segue.destinationViewController as? ArticleWebViewController {
                //商品ページのURLを設定する
                articleWebViewController.articleUrl = cell.articleUrl
            }
        }
    }
}
