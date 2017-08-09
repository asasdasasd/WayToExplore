//
//  ProfileMenuViewCell.swift
//  WayToExplore
//
//  Created by shen on 2017/8/8.
//  Copyright © 2017年 shen. All rights reserved.
//

import UIKit

class ProfileMenuViewCell: UITableViewCell {
    @IBOutlet weak var iconView: UIImageView!

    @IBOutlet weak var unreadLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    var unreadCount: Int = 0 {
        willSet {
            unreadLabel.isHidden = newValue < 1
            unreadLabel.text = "  \(newValue)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        unreadLabel.clipsToBounds = true
        unreadLabel.layer.cornerRadius = 9
        unreadLabel.isHidden = true
    }
    
    func updateTheme() {
        self.backgroundColor = 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
