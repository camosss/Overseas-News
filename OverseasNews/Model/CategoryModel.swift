//
//  CategoryModel.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/26.
//

import Foundation

enum CategorySectionURL: Int, CaseIterable {
    case news
    case entertainment
    case sports
    case scienceAndTechnology
    
    var description: Array<String> {
        switch self {
        case .news: return ["Business", "Politics"]
        case .entertainment: return ["Entertainment_MovieAndTV", "Entertainment_Music"]
        case .sports: return ["Sports_Soccer", "Sports_NBA", "Sports_MLB"]
        case .scienceAndTechnology: return ["Science", "Technology"]
        }
    }
}

enum CategorySectionName: Int, CaseIterable {
    case news
    case entertainment
    case sports
    case scienceAndTechnology
    
    var description: Array<String> {
        switch self {
        case .news: return ["Business", "Politics"]
        case .entertainment: return ["Movie/TV", "Music"]
        case .sports: return ["Soccer", "NBA", "MLB"]
        case .scienceAndTechnology: return ["Science", "Technology"]
        }
    }
}
