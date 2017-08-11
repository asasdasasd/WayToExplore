//
//  API.swift
//  WayToExplore
//
//  Created by shen on 2017/8/10.
//  Copyright © 2017年 shen. All rights reserved.
//

import Foundation
import Moya

enum PrivacyType {
    case online(value: Int)
    case topic(value: Int)
    case search(on: Bool)
}

enum ThankType {
    case topic(id: String)
    case reply(id: String)
}

enum FavoriteType {
    case topic(id: String, token: String)
    case node(id: String, once: String)
}

enum API {
    
    case once()
    
    case login(usernameKey: String, passwordKey: String, username: String, password: String, once: String)
    
    case logout(once: String)
    
    case topics(nodeHref: String)
    
    case dailyRewards(once: String)
    
    case timeline(userHref: String)
    
    case pageList(href: String, page: Int)
    
    case notifications(page: Int)
    
    case favoriteNodes(page: Int)
    
    case favoriteTopics(page: Int)
    
    case favoriteFollowings(page: Int)
    
    case updateAvatar(imageData: Data, once: String)
    
    case privacyOnce()
    
    case privacy(type: PrivacyType, once: String)
    
    case comment(topicHref: String, content: String, once: String)
    
    case thank(type: ThankType, token: String)
    
    case ignoreTopic(id: String, once: String)
    
    case favorite(type: FavoriteType, isCancel: Bool)
    
    case follow(id: String, once: String, isCancel: Bool)
    
    case block(id: String, token: String, isCancel: Bool)
    
    case createTopic(nodeHref: String, title: String, content: String, once: String)

    case twoStepVerify(code: String, once: String)
}

extension API: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.v2ex.com")!
    }
    
    var task: Task {
        switch self {
        case let .updateAvatar(imageData, once):
            return .upload(.multipart([MultipartFormData(provider: .data(imageData), name: "avatar", fileName: "avatar.jpeg", mimeType: "image/jpeg"),MultipartFormData(provider: .data(once.data(using: .utf8)!),name: "once")]))
        default:
            return .request
        }
    }
    
    var path: String {
        switch self {
        case .once():
            return "/signin"
        case .login(_, _, _, _, _):
            return "/signin"
        case .logout(_):
            return "/signout"
        case .dailyRewards(_):
            return "/mission/daily/redeem"
        case let .timeline(userHref):
            return userHref
        case let .pageList(href, _), let .comment(href, _, _):
            if href.contains("#") {
                return href.components(separatedBy: "#").first ?? ""
            }
            return href
        case .notifications(_):
            return "/notifications"
        case .favoriteNodes(_):
            return "/my/nodes"
        case .favoriteTopics(_):
            return "/my/topics"
        case .favoriteFollowings(_):
            return "/my/following"
        case .updateAvatar(_):
            return "/settings/avatar"
        case .privacy(_, _), .privacyOnce():
            return "/settings/privacy"
        case let .thank(type, _):
            switch type {
            case let .topic(id):
                return "/thank/topic/\(id)"
            case let .reply(id):
                return "/thank/reply/\(id)"
            }
        case let .ignoreTopic(id, _):
            return "/ignore/topic/\(id)"
        case let .favorite(type, isCancel):
            switch type {
            case let .topic(id, _):
                return (isCancel ? "/unfavorite" :  "/favorite") + "/topic/\(id)"
            case let .node(id, _):
                return (isCancel ? "/unfavorite" :  "/favorite") + "/node/\(id)"
            }
        case let .follow(id, _, isCancel):
            return (isCancel ? "/unfollow" :  "/follow") + "/\(id)"
        case let .block(id, _, isCancel):
            return (isCancel ? "/unblock" :  "/block") + "/\(id)"
        case let .createTopic(nodeHref, _, _, _):
            return nodeHref.replacingOccurrences(of: "go", with: "new")
        case .twoStepVerify(_, _):
            return "/2fa"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login(_, _, _, _, _):
            return .post
        case .updateAvatar(_), .privacy(_, _), .comment(_, _, _), .thank(_, _), .createTopic(_, _, _, _), .twoStepVerify(_, _):
            return .post
        default:
            return .get
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var parameters: [String : Any]? {
        switch self {
        case let .login(userNameKey, passwordKey, userName, password, once):
            return [userNameKey: userName, passwordKey: password, "once": once, "next": "/"]
        case let .dailyRewards(once), let .logout(once):
            return ["once": once]
        case let .topics(nodeHref):
            if nodeHref.isEmpty {
                return nil
            }
            let node = nodeHref.replacingOccurrences(of: "/?tab=", with: "")
            return ["tab": node]
        case let .pageList(_, page), let .notifications(page):
            return page == 0 ? nil : ["p": page]
        case let .favoriteNodes(page), let .favoriteTopics(page), let .favoriteFollowings(page):
            return page == 0 ? nil : ["p": page]
        case let .privacy(type, once):
            switch type {
            case let .online(value):
                return ["who_can_view_my_online_status": value, "once": once]
            case let .topic(value):
                return ["who_can_view_my_topics_list": value, "once": once]
            case let .search(on):
                return ["topics_indexable": on ? 1 : 0, "once": once]
            }
        case let .comment(_ , content, once):
            return ["content": content, "once": once]
        case let .thank(_, token):
            return ["t": token]
        case let .ignoreTopic(_, once):
            return ["once": once]
        case let .favorite(type, _):
            switch type {
            case let .topic(_, token):
                return ["t": token]
            case let .node(_, once):
                return ["once": once]
            }
        case let .follow(_, once, _):
            return ["once": once]
        case let .block(_, token, _):
            return ["t": token]
        case let .createTopic(_, title, content, once):
            return ["title": title, "content": content, "once": once]
        case let .twoStepVerify(code, once):
            return ["code": code, "once": once]
        default:
            return nil
        }
    }
    
    var sampleData: Data {
        return Data()
    }
}

extension API {
    static let provider = RxMoyaProvider(endpointClosure: endpointClosure, plugins: [networkActivityPlugin])
    
    static func endpointClosure(_ target: API) -> Endpoint<API> {
        let defaultEndpoint = MoyaProvider<API>.defaultEndpointMapping(for: target)
        
        switch target {
        case .once():
            let headers = ["Origin": "https://www.v2ex.com",
                           "Content-Type": "application/x-www-form-urlencoded"]
            return defaultEndpoint.adding(newHTTPHeaderFields: headers)
        case .login(_, _, _, _, _):
            let headers = ["Referer": "https://www.v2ex.com/signin",
                           "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 10_2_1 like Mac OS X) AppleWebKit/602.4.6 (KHTML, like Gecko) Version/10.0 Mobile/14D27 Safari/602.1"]
            return defaultEndpoint.adding(newHTTPHeaderFields: headers)
        default:
            let headers = ["User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 10_2_1 like Mac OS X) AppleWebKit/602.4.6 (KHTML, like Gecko) Version/10.0 Mobile/14D27 Safari/602.1"]
            return defaultEndpoint.adding(newHTTPHeaderFields: headers)
        }
    }
    
    static let networkActivityPlugin = NetworkActivityPlugin { (change: NetworkActivityChangeType) in
        switch change {
        case .began:
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        case .ended:
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
