//
//  ProfileMenuViewCell.swift
//  WayToExplore
//
//  Created by shen on 2017/8/8.
//  Copyright © 2017年 shen. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

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
        self.backgroundColor = AppStyle.shared.theme.tableBackgroundColor
        contentView.backgroundColor = AppStyle.shared.theme.tableBackgroundColor
        let selectedView = UIView()
        selectedView.backgroundColor = AppStyle.shared.theme.cellSelectedBackgroundColor
        self.selectedBackgroundView = selectedView
        
        //difference between upper?
        //self.selectedBackgroundView?.backgroundColor = UIColor.red
        
        nameLabel.textColor = AppStyle.shared.theme.black64Color
    }

    func configure(image: UIImage, text: String) {
        iconView.image = AppStyle.shared.theme == .night ? image.imageWithTintColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)) : image
        nameLabel.text = text
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension Reactive where Base: ProfileMenuViewCell {
    var unread: UIBindingObserver<Base, Int>{
        return UIBindingObserver(UIElement: self.base, binding: { (view, value) in
            view.unreadCount = value
        })
    }
}
