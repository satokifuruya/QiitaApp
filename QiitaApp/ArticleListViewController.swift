//
//  ArticleListViewController.swift
//  QiitaApp
//
//  Created by satoki furuya on 2016/09/13.
//  Copyright © 2016年 satoki furuya. All rights reserved.
//

import UIKit


class ArticleListViewController: UIViewController, UITableViewDataSource, ArticleTableViewDelegate {
    var articles: [[String: String?]] = []
    let articleTableView = ArticleTableView()
    var currentSelectedArticle: Article?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setArticleTableView()
        
    }
    
    func didSelectTableViewCell(article: Article) {
        print("セルがタップされました。")
        self.currentSelectedArticle = article
        self.performSegueWithIdentifier("ShowToArticleWebViewController", sender: nil)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        let article = articles[indexPath.row]
        cell.textLabel?.text = article["title"]!
        cell.detailTextLabel?.text = article["userId"]!
        return cell
    }
    
    
    func setArticleTableView(){
        let frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let articleTableView = ArticleTableView(frame: frame, style: UITableViewStyle.Plain)
        articleTableView.customDelegate = self
        articleTableView.getArticles()
        
        
        // リフレッシュコントロールの設定をしてテーブルビューに追加
        articleTableView.refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        articleTableView.refreshControl.addTarget(articleTableView, action: #selector(articleTableView.refresh), forControlEvents: UIControlEvents.ValueChanged)
        articleTableView.addSubview(articleTableView.refreshControl)
        self.view.addSubview(articleTableView)
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let articleWebViewController = segue.destinationViewController as! ArticleWebViewController
        articleWebViewController.article = self.currentSelectedArticle
    }
}