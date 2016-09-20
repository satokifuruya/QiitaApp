//
//  MyPageViewController.swift
//  QiitaApp
//
//  Created by satoki furuya on 2016/09/15.
//  Copyright © 2016年 satoki furuya. All rights reserved.
//

import UIKit

class MyPageViewController: UITableViewController {
    @IBOutlet weak var viewModeButton: UIBarButtonItem!
    
    
    var bookmarkArticles = BookmarkArticle.sharedInstance
    var visivbleBookmarkMode = 1 //0はすべて,1は未読のみ表示
    var imageCache = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    @IBAction func tapViewModeButton(sender: UIBarButtonItem) {
        if visivbleBookmarkMode == 0 {
            visivbleBookmarkMode = 1
            viewModeButton.title = "すべて表示"
        } else {
            visivbleBookmarkMode = 0
            viewModeButton.title = "未読を表示"
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if visivbleBookmarkMode == 1 {
            return self.bookmarkArticles.unreadBookmarks.count
        }
        return self.bookmarkArticles.bookmarks.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    
    //テーブルセルの取得処理
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArticleTableViewCell", forIndexPath: indexPath) as! ArticleTableViewCell
        
        var article = self.bookmarkArticles.bookmarks[indexPath.row]
        
        if visivbleBookmarkMode == 1 {
            article = self.bookmarkArticles.unreadBookmarks[indexPath.row]
        }
        
        
        
        cell.titleLabel.text = article.title
        cell.userIdLabel.text = article.userId
        
        if article.finishReading {
            cell.titleLabel.textColor = UIColor.grayColor()
            cell.userIdLabel.textColor = UIColor.grayColor()
        } else {
            cell.titleLabel.textColor = UIColor.blackColor()
            cell.userIdLabel.textColor = UIColor.blackColor()
        }
        
        cell.article = article
        
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
    
    
    //開くとリロード
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    //TODO: check
    //セルがタップされた時に呼ばれるメソッド
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var article = self.bookmarkArticles.bookmarks[indexPath.row]
        if visivbleBookmarkMode == 1 {
            article = self.bookmarkArticles.unreadBookmarks[indexPath.row]
        }
        self.performSegueWithIdentifier("ShowToArticleWebViewController", sender: article)
    }
    
    
    //画面遷移時に呼ばれるメソッド
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let articleWebViewController = segue.destinationViewController as! ArticleWebViewController
        articleWebViewController.article = sender as! Article!
        articleWebViewController.navigationItem.title = sender?.title
        segue.destinationViewController.hidesBottomBarWhenPushed = true
    }
    
    //TODO: check
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            print("delete呼ばれた")
            var article = self.bookmarkArticles.bookmarks[indexPath.row]
            if  visivbleBookmarkMode == 1{
                article = self.bookmarkArticles.unreadBookmarks[indexPath.row]
            }
            bookmarkArticles.removeBookmark(article)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        default:
            return
        }
    }
    
}