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
        Alamofire.request(.GET, "https://qiita.com/api/v2/items")
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
        
        getArticles()
        
//        if inputText?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
//                        //保持している商品を一旦削除
//            articleArray.removeAll()
//            
//            //パラメータを指定する
//            let parameter = ["appid":appid, "query":inputText]
//            
//            //パラメータをエンコードしたURLを作成する
//            let requestUrl = createRequestUrl(parameter)
//            
//            //APIをリクエストする
//            request(requestUrl)
//        }
        //キーボードを閉じる
        searchBar.resignFirstResponder()
        
    }
//        //商品検索を行なう
//        let inputText = searchBar.text
//        //入力文字数が0文字以上かどうかチェックする
//        if inputText?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
//            //保持している商品を一旦削除
//            itemDataArray.removeAll()
//            
//            //パラメータを指定する
//            let parameter = ["appid":appid, "query":inputText]
//            
//            //パラメータをエンコードしたURLを作成する
//            let requestUrl = createRequestUrl(parameter)
//            
//            //APIをリクエストする
//            request(requestUrl)
//        }
//        //キーボードを閉じる
//        searchBar.resignFirstResponder()
//    }
//    
//    //URL作成処理
//    func createRequestUrl(parameter :[String:String?]) -> String {
//        var parameterString = ""
//        for key in parameter.keys {
//            if let value = parameter[key] {
//                //既にパラメータが設定されていた場合
//                if parameterString.lengthOfBytesUsingEncoding(
//                    NSUTF8StringEncoding) > 0 {
//                    parameterString += "&"
//                }
//                
//                //値をエンコードする
//                if let escapedValue =
//                    value!.stringByAddingPercentEncodingWithAllowedCharacters(
//                        NSCharacterSet.URLQueryAllowedCharacterSet()) {
//                    parameterString += "\(key)=\(escapedValue)"
//                }
//            }
//        }
//        let requestUrl = entryUrl + "?" + parameterString
//        return requestUrl
//    }
//    
//    //リクエストを行なう
//    func request(requestUrl: String) {
//        //商品検索APIをコールして商品検索を行なう
//        let session = NSURLSession.sharedSession()
//        
//        if let url = NSURL(string: requestUrl){
//            let request = NSURLRequest(URL: url)
//            
//            let task = session.dataTaskWithRequest(request, completionHandler: {
//                (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
//                //エラーチェック
//                if error != nil {
//                    //エラー表示
//                    let alert = UIAlertController(title: "エラー",
//                        message: error?.description,
//                        preferredStyle: UIAlertControllerStyle.Alert)
//                    //UIに関する処理はメインスレッド上で行なう
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        self.presentViewController(alert, animated: true, completion: nil)
//                    })
//                    return
//                }
//                
//                //Jsonで返却されたデータをパースして格納する
//                if let data = data {
//                    let jsonData = try! NSJSONSerialization.JSONObjectWithData(
//                        data, options: NSJSONReadingOptions.AllowFragments)
//                    
//                    //データのパース処理
//                    if let resultSet = jsonData["ResultSet"] as? [String:AnyObject] {
//                        self.parseData(resultSet)
//                    }
//                    
//                    //テーブルの描画処理を実施
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        self.tableView.reloadData()
//                    })
//                }
//            })
//            task.resume()
//        }
//    }
//    
//    //検索結果をパースして商品リストを作成する
//    func parseData(resultSet: [String:AnyObject]) {
//        if let firstObject = resultSet["0"] as? [String:AnyObject] {
//            if let results = firstObject["Result"] as? [String:AnyObject] {
//                for key in results.keys.sort() {
//                    
//                    //Requestのキーは無視する
//                    if key == "Request" {
//                        continue
//                    }
//                    
//                    //商品アイテム取得処理
//                    if let result = results[key] as? [String:AnyObject] {
//                        //商品データ格納オブジェクト作成
//                        let itemData = ItemData()
//                        
//                        //画像を格納
//                        if let itemImageDic = result["Image"] as? [String:AnyObject] {
//                            let itemImageUrl = itemImageDic["Medium"] as? String
//                            itemData.itemImageUrl = itemImageUrl
//                        }
//                        
//                        //商品タイトルを格納
//                        let itemTitle = result["Name"] as? String //商品名
//                        itemData.itemTitle = itemTitle
//                        
//                        //商品価格を格納
//                        if let itemPriceDic = result["Price"] as? [String:AnyObject] {
//                            let itemPrice = itemPriceDic["_value"] as? String
//                            itemData.itemPrice = itemPrice
//                        }
//                        
//                        //商品のURLを格納
//                        let itemUrl = result["Url"] as? String
//                        itemData.itemUrl = itemUrl
//                        
//                        //商品リストに追加
//                        self.itemDataArray.append(itemData)
//                    }
//                }
//            }
//        }
//    }
    
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
