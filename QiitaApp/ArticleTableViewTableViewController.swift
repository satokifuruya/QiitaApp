//
//  ArticleTableViewTableViewController.swift
//  QiitaApp
//
//  Created by satoki furuya on 2016/09/13.
//  Copyright © 2016年 satoki furuya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

@objc protocol ArticleTableViewDelegate {
    func didSelectTableViewCell(article: Article)
}

class ArticleTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    weak var customDelegate: ArticleTableViewDelegate?
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    var articles:Array<Article> = []
    
    
    //商品画像のキャッシュを管理するクラス
    var imageCache = NSCache()
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
        
        self.registerNib(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //セル数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.articles.count
    }
    
    //セル内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArticleTableViewCell", forIndexPath: indexPath) as! ArticleTableViewCell
        cell.iconImage.image = UIImage(named: "iphone")
        let article = self.articles[indexPath.row]
        cell.titleLabel.text = article.title
        cell.userIdLabel.text = article.userId
        
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
    
    //セルの高さ
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let article = articles[indexPath.row]
        self.customDelegate?.didSelectTableViewCell(article)
    }
    
    func refresh(){
        print("call refresh.")
        getArticles()
        self.refreshControl.endRefreshing()
    }
    
    func getArticles() {
        print("呼ばれた")
        Alamofire.request(.GET, "https://qiita.com/api/v2/items")
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                
                self.articles.removeAll()
                let json = JSON(object)
                json.forEach { (_, json) in
                    let article = Article()
                    article.title = json["title"].string!
                    article.articleUrl = json["url"].string!
                    article.userId = json["user"]["id"].string!
                    article.iconImageUrl = json["user"]["profile_image_url"].string!
                    self.articles.append(article)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.reloadData()
                })
        }
    }
    
}
