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
    

    func getMyBookmarkArticles(){
        let realm = try! Realm()
        
        for realmArticle in realm.objects(Article) {
            self.bookmarks.append(realmArticle)
        }
    }
    
    func addBookmarkArticle(article: Article){
        self.bookmarks.insert(article, atIndex: 0)
        addBookmarkArticleToRealm(article)
    }
    
    func removeBookmark(article: Article){
        removeBookmarArticleFromRealm(article)
    }
    
    func addBookmarkArticleToRealm(article: Article){
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
    
    
    func removeBookmarArticleFromRealm(article: Article){
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
