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
    
    
    //APIのURL
    let entryUrl: String = "https://qiita.com/api/v2/items"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.refreshControl = UIRefreshControl()
//        self.refreshControl?.attributedTitle = NSAttributedString(string: "引っ張って更新")
//        self.refreshControl?.addTarget(self, action: #selector(ArticleTableViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        getArticles()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refresh() {
        print("call refresh.")
        getArticles()
        self.refreshControl?.endRefreshing()
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    
    func getArticles() {
        print("getArticles 呼ばれた")
        Alamofire.request(.GET, entryUrl)
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                
                self.articleArray.removeAll()
                let json = JSON(object)
                json.forEach { (_, json) in
                    let article = Article()
                    article.title = json["title"].string!
                    article.articleUrl = json["url"].string!
                    article.userId = json["user"]["id"].string!
                    article.iconImageUrl = json["user"]["profile_image_url"].string!
                    self.articleArray.append(article)
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
        }
    }
    
    func getSearchResultArticles(requestUrl: String) {
        print("検索 呼ばれた")
        Alamofire.request(.GET, requestUrl)
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                
                self.articleArray.removeAll()
                let json = JSON(object)
                json.forEach { (_, json) in
                    let article = Article()
                    article.title = json["title"].string!
                    article.articleUrl = json["url"].string!
                    article.userId = json["user"]["id"].string!
                    article.iconImageUrl = json["user"]["profile_image_url"].string!
                    self.articleArray.append(article)
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
        }
    }
    
    //以下参考
    // MARK: - search bar delegate
    //キーボードのsearchボタンがタップされた時に呼び出される
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        print("検索した")
        let inputText = searchBar.text
        
        //パラメータを指定する
        let parameter = ["query":inputText]
        
        //パラメータをエンコードしたURLを作成する
        let requestUrl = createRequestUrl(parameter)

        //検索を行う
        getSearchResultArticles(requestUrl)
        
        //キーボードを閉じる
        searchBar.resignFirstResponder()
        
    }

//    //URL作成処理
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
        let requestUrl = entryUrl + "?" + parameterString
        return requestUrl
    }

    
    // MARK: - Table view data source
    //テーブルセルの取得処理
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("テーブル描画呼ばれた")
        let cell = tableView.dequeueReusableCellWithIdentifier("articleCell", forIndexPath: indexPath) as! ArticleTableViewCell
        let article = articleArray[indexPath.row]
        cell.titleLabel.text = article.title
        cell.userIdLabel.text = article.userId
        
        cell.articleUrl = article.articleUrl
        
        //画像処理↓
        //画像がまだ設定されていない場合に処理を行なう
        if let iconImageUrl = article.iconImageUrl {
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
