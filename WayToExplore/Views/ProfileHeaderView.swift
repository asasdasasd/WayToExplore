//
//  ProfileHeaderView.swift
//  WayToExplore
//
//  Created by shen on 2017/8/8.
//  Copyright © 2017年 shen. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {

    
    //if cannot drag out outlet from storyboard, you can write code first then drag outlet from code to storyboard, it's xcode bug!!!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.red
    }
}
