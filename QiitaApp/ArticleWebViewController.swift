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
    
    //商品ページのURL
    var articleUrl :String?
    
    //商品ページを参照するためのWebView
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //WebViewのurlを読み込ませてWebページを表示させる
        if let articleUrl = articleUrl {
            if let url = NSURL(string: articleUrl) {
                let request = NSURLRequest(URL: url)
                webView.loadRequest(request)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
