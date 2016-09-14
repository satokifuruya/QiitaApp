//
//  ArticleTableViewCell.swift
//  QiitaApp
//
//  Created by satoki furuya on 2016/09/13.
//  Copyright © 2016年 satoki furuya. All rights reserved.
//
//articleTableViewは使わない
import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    
    var articleUrl :String? //商品ページのURL。遷移先の画面で利用する
    
    //articleTableViewは使わない
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
