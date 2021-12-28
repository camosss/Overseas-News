//
//  APIModel.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/21.
//

import Foundation

struct Search {
    let category: String
    let title: String
    let description: String
    let postImage: String
    let url: String
    let datePublished: String
    let providerName: String
}

struct SearchData: Codable {
    var articles: [Article]
}

struct Article: Codable {
    let title: String
    let author: String?
    let publishedDate: String
    let link: String
    let summary: String
    let media: String?
    let topic: String

    enum CodingKeys: String, CodingKey {
        case title, link, summary, author, media, topic
        case publishedDate = "published_date"
    }
}
