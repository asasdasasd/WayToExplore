//
//  User.swift
//  WayToExplore
//
//  Created by shen on 2017/8/8.
//  Copyright © 2017年 shen. All rights reserved.
//

import Foundation

struct User {
    var name: String = ""
    var href: String = ""
    var src: String = ""
    
    init(name: String, href: String, src: String) {
        self.name = name
        self.href = href
        self.src = src
    }
}

extension User {
    enum Avater: String {
        case normal = "_normal.", mini = "_mini.", large = "_large."
    }
    var srcURLString: String {
        return "https:" + src
    }
    
    func avatar(_ type: Avater) -> String {
        let arr = ["_normal.","_mini.","_large."]
        if let index = arr.index(where: { (string) -> Bool in
            srcURLString.hasSuffix(string)
        }){
            return srcURLString.replacingOccurrences(of: arr[index], with: type.rawValue)
        }
        return srcURLString
    }
}



