//
//  APIModel.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/21.
//

import Foundation

struct TrendingTopic {
    let title: String
    let snippet: String
    let postImage: String
    let url: String
    let provider: String
    let datePublished: String
}

struct Search {
    let category: String
    let title: String
    let description: String
    let postImage: String
    let url: String
    let datePublished: String
    let providerName: String
}


struct Article {
    let title: String
    let description: String
    let postImage: String
    let url: String
    let datePublished: String
    let providerName: String
}

enum Category: Int, CaseIterable {
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
