//
//  MyPageViewController.swift
//  QiitaApp
//
//  Created by satoki furuya on 2016/09/15.
//  Copyright © 2016年 satoki furuya. All rights reserved.
//

import UIKit
import RealmSwift
import AlamofireImage

class MyPageViewController: UITableViewController {

    @IBOutlet weak var viewModeButton: UIBarButtonItem!
    
    var bookmarkArticles = BookmarkArticle.sharedInstance
    var visivbleBookmarkMode = BookmarkViewType.UnRead
    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
        navigationItem.leftBarButtonItem = editButtonItem()
        
        setRealmNotification()
        
    }
    
    private func setRealmNotification() {
        //realm.objects(Article)のオブジェクトが更新されたら通知
        let realm = try! Realm()
        token = realm.objects(Article).addNotificationBlock() { (changes: RealmCollectionChange) in
            switch changes {
            case .Initial:
                break
            case .Update:
                self.tableView.reloadData()
            case .Error:
                break
            }
        }
    }
    
    @IBAction func tapViewModeButton(sender: UIBarButtonItem) {
        if visivbleBookmarkMode == .All {
            visivbleBookmarkMode = .UnRead
            viewModeButton.title = BookmarkViewType.All.getTitle()
        } else {
            visivbleBookmarkMode = .All
            viewModeButton.title = BookmarkViewType.UnRead.getTitle()
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
        if visivbleBookmarkMode == .UnRead {
            return self.bookmarkArticles.unreadBookmarks!.count
        }
        return self.bookmarkArticles.bookmarks!.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    
    //テーブルセルの取得処理
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArticleTableViewCell", forIndexPath: indexPath) as! ArticleTableViewCell
        
        var article = self.bookmarkArticles.bookmarks![indexPath.row]
        
        if visivbleBookmarkMode == .UnRead {
            article = self.bookmarkArticles.unreadBookmarks![indexPath.row]
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
        
        //画像
        let iconImageUrl = NSURL(string: article.iconImageUrl)!
        cell.iconImage!.af_setImageWithURL(
            iconImageUrl,
            placeholderImage: UIImage(named: "qiita_default")
        )
        
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
        var article = self.bookmarkArticles.bookmarks![indexPath.row]
        if visivbleBookmarkMode == .UnRead {
            article = self.bookmarkArticles.unreadBookmarks![indexPath.row]
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
            var article = self.bookmarkArticles.bookmarks![indexPath.row]
            if  visivbleBookmarkMode == .UnRead {
                article = self.bookmarkArticles.unreadBookmarks![indexPath.row]
            }
            bookmarkArticles.removeBookmark(article)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        default:
            return
        }
    }
    
}
