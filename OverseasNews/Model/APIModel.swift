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
