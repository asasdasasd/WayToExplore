//
//  AppStyle.swift
//  WayToExplore
//
//  Created by shen on 2017/8/9.
//  Copyright © 2017年 shen. All rights reserved.
//

import UIKit
import RxSwift

let nightOnKey = "theme.night.on"

struct AppStyle {
    
    static var shared = AppStyle()
    
    let themeUpdateVariable = Variable<Bool>(false)
    var css: String = ""
   
    var theme: Theme = UserDefaults.standard.bool(forKey: nightOnKey) ? .night : .normal {
        didSet {
            UserDefaults.standard.set(theme == .night, forKey: nightOnKey)
            self.themeUpdateVariable.value = true
        }
    }
    
    
    private init() {
        if let stylePath = Bundle.main.path(forResource: "style", ofType: "css")
        {
            do {
                self.css = try String(contentsOfFile: stylePath,encoding: .utf8)
            } catch {
                print("load css error")
            }
            
        }
    }
    
    func setupBarStyle(_ navigationBar: UINavigationBar = UINavigationBar.appearance()) {
        navigationBar.isTranslucent = false
        navigationBar.tintColor = theme.tintColor
        navigationBar.barTintColor = theme.barTintColor
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: theme.navigationBarTitleColor, NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
        navigationBar.backIndicatorImage = #imageLiteral(resourceName: "nav_back")
        navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "nav_back")
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 16)], for: .normal)
    }
}
