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
    
    func addBookmarkArticle(article: Article){
        self.bookmarks.insert(article, atIndex: 0)
    }
    
}
