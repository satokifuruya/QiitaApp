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
    
    private override init() {
        //シングルトンであることを保証するためにprivateで宣言しておく
    }
    
    func getMyBookmarkArticles(){
        let realm = try! Realm()
        
        for realmArticle in realm.objects(Article) {
            self.bookmarks.insert(realmArticle, atIndex: 0)
        }
    }
    
    func addBookmarkArticle(article: Article){
        self.bookmarks.insert(article, atIndex: 0)
        addBookmarkArticleToRealm(article)
    }
    
    func removeBookmark(index: Int){
        let targetArticle = self.bookmarks[index]
        self.bookmarks.removeAtIndex(index)
        removeBookmarArticleFromRealm(targetArticle)
    }
    
    func changeReadingStatus(article: Article) ->String{
        if article.finishReading{
            undoFinishedReading(article)
            return "この記事はまだ読み途中です"
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
