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



//class ArticleWebViewController: UIViewController, WKNavigationDelegate {
//    let wkWebView = WKWebView()
//    var article: Article!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let URL = NSURL(string: article.articleUrl!)
//        
//        let URLReq = NSURLRequest(URL: URL!)
//        
//        self.wkWebView.navigationDelegate = self
//        self.wkWebView.frame = self.view.frame
//        self.wkWebView.loadRequest(URLReq)
//        self.view.addSubview(wkWebView)
//        
//        //        self.navigationController!.setNavigationBarHidden(false, animated: true)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        self.navigationItem.title = "読み込み中..."
//        //Webページの読み込みを開始したタイミングで実行したい処理
//        
//    }
//    
//    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
//        self.navigationItem.title = wkWebView.title
//        //Webページの読み込みが終了したタイミングで実行したい処理
//        
//    }
//    
//}
