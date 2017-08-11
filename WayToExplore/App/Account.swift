//
//  Account.swift
//  WayToExplore
//
//  Created by shen on 2017/8/10.
//  Copyright © 2017年 shen. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Kanna

struct Privacy {
    
    // who can watch my state 0:everyoen 1:loggedIn 2: myself
    var online: Int = 0
    
    //who can see my topic 0:everyone 1:loggedIn 2: myself
    var topic: Int = 0
    
    //search engine can search my topic
    var search: Bool = true
}

struct Account {
    let isDailyRewards = Variable<Bool>(false)
    let unreadCount = Variable<Int>(0)
    
    let user = Variable<User?>(nil)
    let isLoggedIn = Variable<Bool>(false)
    
    var privacy: Privacy = Privacy()
    
    private let disposeBag = DisposeBag()
    
    static var shared = Account()
    
    private init(){
        
    }
    
    mutating func logout() {
        isLoggedIn.value = false
        user.value = nil
        HTTPCookieStorage.shared.cookies?.forEach({ (cookie) in
            HTTPCookieStorage.shared.deleteCookie(cookie)
            
        })
        
        
    }
    

}
