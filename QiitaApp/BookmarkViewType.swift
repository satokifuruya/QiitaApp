//
//  BookmarkViewType.swift
//  QiitaApp
//
//  Created by satoki furuya on 2016/09/23.
//  Copyright © 2016年 satoki furuya. All rights reserved.
//

import Foundation

enum BookmarkViewType {
    case All
    case UnRead
    
    func getTitle() -> String {
        switch self {
        case .All:
            return "すべて表示"
        case .UnRead:
            return "未読のみ表示"
        }
    }
}
