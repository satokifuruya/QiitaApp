//
//  ArticleTableViewCell.swift
//  QiitaApp
//
//  Created by satoki furuya on 2016/09/15.
//  Copyright © 2016年 satoki furuya. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    
    //web viewへ遷移するときにarticleオブジェクトの情報を保持したい
    var article :Article?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        //再利用時に元々入っている情報をクリア
        iconImage.image = nil
    }
    
}
