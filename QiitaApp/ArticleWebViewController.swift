//
//  ArticleWebViewController.swift
//  QiitaApp
//
//  Created by satoki furuya on 2016/09/13.
//  Copyright © 2016年 satoki furuya. All rights reserved.
//

import UIKit
import WebKit


class ArticleWebViewController: UIViewController {
    
    //URLではなくArticleを保持するように変更した
    var article: Article!
    var bookmarkArticle = BookmarkArticle.sharedInstance
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //WebViewのurlを読み込ませてWebページを表示させる
        let articleUrl = NSURL(string: self.article.articleUrl)
        let request = NSURLRequest(URL: articleUrl!)
        webView.loadRequest(request)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func tapBookmarkButton(sender: UIBarButtonItem) {
        if isStockedArticle() {
            showAlert("既に登録してあります。")
        } else {
            self.bookmarkArticle.addBookmarkArticle(article)
            showAlert("ブックマークに保存しました。")
            
        }
    }
    
    
    func isStockedArticle() -> Bool {
        for myArticle in self.bookmarkArticle.bookmarks {
            if myArticle.articleUrl == self.article.articleUrl {
                return true
            }
        }
        return false
    }
    
    
    // ボタンを押下した時にアラートを表示するメソッド
    func showAlert(text: String) {
        let alert: UIAlertController = UIAlertController(title: text, message: nil, preferredStyle:  UIAlertControllerStyle.Alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
        
        alert.addAction(defaultAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
}
