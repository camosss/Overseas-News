//
//  SettingOption.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/25.
//

import Foundation

enum SettingOption: Int, CaseIterable {
    case sendfeedback
    case appStore
    case license
    
    var description: String {
        switch self {
        case .sendfeedback: return "Send Feedback"
        case .appStore: return "Leave App Store Ratings and Reviews"
        case .license: return "Open Source License"
        }
    }
}

enum LicenseOption: Int, CaseIterable {
    case alamofire
    case waterfallLayot
    case kingfisher
    case pageboy
    case realm
    case skeletonView
    case snapkit
    case swiftyJSON
    case tabman
    case toast
    
    var description: String {
        switch self {
        case .alamofire: return "Alamofire"
        case .waterfallLayot: return "CHTCollectionViewWaterfallLayout"
        case .kingfisher: return "Kingfisher"
        case .pageboy: return "Pageboy"
        case .realm: return "Realm"
        case .skeletonView: return "SkeletonView"
        case .snapkit: return "Snapkit"
        case .swiftyJSON: return "SwiftyJSON"
        case .tabman: return "Tabman"
        case .toast: return "Toast-Swift"
        }
    }
}
