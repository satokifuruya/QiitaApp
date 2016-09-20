//
//  UserSettingEntity.swift
//  QiitaApp
//
//  Created by satoki furuya on 2016/09/20.
//  Copyright © 2016年 satoki furuya. All rights reserved.
//

import UIKit
import RealmSwift


let SHOW_ALL_ARTICLES = 0
let SHOW_UNREAD_ARTICLES = 1


class UserSettingEntity: Object {
    dynamic var name = ""
    //マイページで読み終わった記事を表示するか
    dynamic var mypageViewMode = SHOW_ALL_ARTICLES

}
