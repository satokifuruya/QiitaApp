//
//  ArticleListViewController.swift
//  QiitaApp
//
//  Created by satoki furuya on 2016/09/13.
//  Copyright © 2016年 satoki furuya. All rights reserved.
//

import UIKit
//↓後で消す
//import RealmSwift


class ArticleListViewController: UIViewController, UITableViewDataSource, ArticleTableViewDelegate, UISearchBarDelegate {
    
    var articles: [[String: String?]] = []
    let articleTableView = ArticleTableView()
    var currentSelectedArticle: Article?
    var searchBar: UISearchBar!
    @IBOutlet weak var serchBarButton: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setArticleTableView()
    }
    
    //ナビゲーションに検索バーを追加
    private func setupSearchBar() {
        if let navigationBarFrame = navigationController?.navigationBar.bounds {
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.delegate = self
            searchBar.placeholder = "Search"
            searchBar.autocapitalizationType = UITextAutocapitalizationType.None
            searchBar.keyboardType = UIKeyboardType.Default
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            self.searchBar = searchBar
        }
    }
    
    
    //検索ボタンが押された時の処理
    @IBAction func tapSerchBarButton(sender: UIBarButtonItem) {
        setArticleTableView()
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        print("検索ボタンおした")
        searchBar.resignFirstResponder()
        articleTableView.getSearchResultArticles()
        
    }
    

    
    func didSelectTableViewCell(article: Article) {
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
        let frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.width, self.view.frame.height)
        let articleTableView = ArticleTableView(frame: frame, style: UITableViewStyle.Plain)
        articleTableView.customDelegate = self
//        articleTableView.getArticles()
        
        
        // リフレッシュコントロールの設定をしてテーブルビューに追加
//        articleTableView.refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
//        articleTableView.refreshControl.addTarget(articleTableView, action: #selector(articleTableView.refresh), forControlEvents: UIControlEvents.ValueChanged)
//        articleTableView.addSubview(articleTableView.refreshControl)
//        self.view.addSubview(articleTableView)
    }
    
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let articleWebViewController = segue.destinationViewController as! ArticleWebViewController
//        articleWebViewController.article = self.currentSelectedArticle
//    }
}