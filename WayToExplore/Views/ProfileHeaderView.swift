//
//  ProfileHeaderView.swift
//  WayToExplore
//
//  Created by shen on 2017/8/8.
//  Copyright © 2017年 shen. All rights reserved.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

class ProfileHeaderView: UIView {

    
    //if cannot drag out outlet from storyboard, you can write code first then drag outlet from code to storyboard, it's xcode bug!!!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var user: User? {
        willSet {
            if let model = newValue {
                avatarButton.setTitle("", for: .normal)
                avatarButton.kf.setBackgroundImage(with: URL(string:model.avatar(.large)), for: .normal)
                nameLabel.text = model.name
                nameLabel.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.red
        
        avatarButton.clipsToBounds = true
        avatarButton.layer.cornerRadius = 40
        nameLabel.isHidden = true
        
        updateTheme()
    }
    
    func updateTheme() {
        
    }
    
    func logout() {
        avatarButton.setTitle("登录", for: .normal)
        avatarButton.setBackgroundImage(nil, for: .normal)
        nameLabel.isHidden = true
    }
}

extension Reactive where Base: ProfileHeaderView {
    var user: UIBindingObserver<Base, User?> {
        return UIBindingObserver(UIElement: self.base){ view, value in
            view.user = value
        }
    }
    
    var isLoginEnabled: UIBindingObserver<Base, Bool> {
        return UIBindingObserver(UIElement: self.base, binding: { (view, value) in
            view.avatarButton.isUserInteractionEnabled = value
        })
    }
}


