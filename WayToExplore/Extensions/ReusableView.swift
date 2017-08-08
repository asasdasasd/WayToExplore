//
//  ReusableView.swift
//  WayToExplore
//
//  Created by shen on 2017/8/8.
//  Copyright © 2017年 shen. All rights reserved.
//

import UIKit

protocol ResuableView: class {
    static var reuseId: String {get}
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T where T: ResuableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseId) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseId)")
        }
        return cell
    }
}
