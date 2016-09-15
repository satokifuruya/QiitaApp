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
    
    //商品ページを参照するためのWebView
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
        
    }
    
}
