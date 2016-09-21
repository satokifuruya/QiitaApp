//
//  BookmarkArticle.swift
//  QiitaApp
//
//  Created by satoki furuya on 2016/09/15.
//  Copyright © 2016年 satoki furuya. All rights reserved.
//

import UIKit
import RealmSwift

class BookmarkArticle: NSObject {

    static let sharedInstance =  BookmarkArticle()
    var bookmarks :Results<Article>?
    var unreadBookmarks :Results<Article>?
    var token: NotificationToken?
    
    private override init() {
        //シングルトンであることを保証するためにprivateで宣言しておく
    }
    
    func getMyBookmarkArticles(){
        let realm = try! Realm()
        self.bookmarks = realm.objects(Article)
        self.unreadBookmarks = self.bookmarks!.filter("finishReading = false")
        
        //realm.objects(Article)のオブジェクトが更新されたら通知
        token = realm.objects(Article).addNotificationBlock() { (changes: RealmCollectionChange) in
            switch changes {
            case .Initial:
                break
            case .Update:
                NSNotificationCenter.defaultCenter().postNotificationName("UpdateBookmarksNotification", object: nil)
            case .Error:
                break
            }
        }
    }
    
    func addBookmarkArticle(article: Article){
        addBookmarkArticleToRealm(article)
    }
    
    //TODO: check
    func removeBookmark(article: Article){
        removeBookmarArticleFromRealm(article)
    }
    
    
    func changeReadingStatus(article: Article) ->String{
        if article.finishReading{
            undoFinishedReading(article)
            return "この記事を未読にしました"
        } else {
            finishedReading(article)
            return "この記事を読み終えました"
        }
    }
    
    
    private func finishedReading(article: Article){
        let realm = try! Realm()
        if let targetArticle = realm.objects(Article).filter("articleUrl = %@", article.articleUrl).first {
            try! realm.write {
                targetArticle.finishReading = true
            }
        } else {
            print("not found bookmark")
        }
    }
    
    private func undoFinishedReading(article: Article){
        let realm = try! Realm()
        if let targetArticle = realm.objects(Article).filter("articleUrl = %@", article.articleUrl).first {
            try! realm.write {
                targetArticle.finishReading = false
            }
        } else {
            print("not found bookmark")
        }
    }
    
    private func addBookmarkArticleToRealm(article: Article){
        let realm = try! Realm()
        let bookmarkArticle = Article()
        bookmarkArticle.title = article.title
        bookmarkArticle.userId  = article.userId
        bookmarkArticle.articleUrl = article.articleUrl
        bookmarkArticle.iconImageUrl = article.iconImageUrl
        try! realm.write {
            realm.add(bookmarkArticle)
        }
    }
    
    
    private func removeBookmarArticleFromRealm(article: Article){
        let realm = try! Realm()
        if let targetArticle = realm.objects(Article).filter("articleUrl = %@", article.articleUrl).first {
            try! realm.write {
                realm.delete(targetArticle)
            }
        } else {
            print("not found bookmark")
        }
    }
    
}
