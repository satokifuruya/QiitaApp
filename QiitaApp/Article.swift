//
//  Article.swift
//  QiitaApp
//
//  Created by satoki furuya on 2016/09/13.
//  Copyright © 2016年 satoki furuya. All rights reserved.
//

import UIKit
import RealmSwift

class Article: Object {
    dynamic var title = ""
    dynamic var iconImageUrl  = "https://qiita-image-store.s3.amazonaws.com/0/88/profile-images/1473684075"
    dynamic var userId  = ""
    dynamic var articleUrl  = ""
}
