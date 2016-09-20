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
    var bookmarks : Array<Article> = []
    var unreadBookmarks: Array<Article> = []
    
    private override init() {
        //シングルトンであることを保証するためにprivateで宣言しておく
    }
    
    func getMyBookmarkArticles(){
        let realm = try! Realm()
        
        for realmArticle in realm.objects(Article) {
            self.bookmarks.insert(realmArticle, atIndex: 0)
        }
        getCurrentUnreadBookmarks()
        
    }
    
    func addBookmarkArticle(article: Article){
        self.bookmarks.insert(article, atIndex: 0)
        addBookmarkArticleToRealm(article)
        getCurrentUnreadBookmarks()
    }
    
    //TODO: check
    func removeBookmark(article: Article){
        let tagetIndex = self.bookmarks.indexOf(article)!
        let targetArticle = self.bookmarks[tagetIndex]
        self.bookmarks.removeAtIndex(tagetIndex)
        removeBookmarArticleFromRealm(targetArticle)
        getCurrentUnreadBookmarks()
    }
    
    func changeReadingStatus(article: Article) ->String{
        if article.finishReading{
            undoFinishedReading(article)
            getCurrentUnreadBookmarks()
            return "この記事はまだ読み途中です"
        } else {
            finishedReading(article)
            getCurrentUnreadBookmarks()
            return "この記事を読み終えました"
        }
    }
    
    
    private func getCurrentUnreadBookmarks() {
        self.unreadBookmarks.removeAll()
        let allBookmarks = self.bookmarks
        for alrticle in allBookmarks {
            if !(alrticle.finishReading){
                self.unreadBookmarks.append(alrticle)
            }
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
