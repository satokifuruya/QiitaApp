//
//  UserSettings.swift
//  QiitaApp
//
//  Created by satoki furuya on 2016/09/20.
//  Copyright © 2016年 satoki furuya. All rights reserved.
//

import UIKit
import RealmSwift

class UserSettingsModel: NSObject {
    
    static let sharedInstance =  UserSettingsModel()
    
    private override init() {
        //シングルトンであることを保証するためにprivateで宣言しておく
    }
    
    

}
