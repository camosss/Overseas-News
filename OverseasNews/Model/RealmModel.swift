//
//  RealmModel.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/21.
//

import Foundation
import RealmSwift

// MARK: - Trending

class TrendingModel: Object {
    @Persisted var title: String
    @Persisted var snippet: String
    @Persisted var postImage: String
    @Persisted var url: String
    @Persisted var datePublished = Date()
    @Persisted var provider: String
        
    convenience init(title: String, snippet: String, postImage: String, url: String, datePublished: Date, provider: String) {
        self.init()
        self.title = title
        self.snippet = snippet
        self.postImage = postImage
        self.url = url
        self.datePublished = datePublished
        self.provider = provider
    }
}

class SaveTrending: Object {
    @Persisted var saveDate: String
    @Persisted var trendingModels: List<TrendingModel>

    convenience init(saveDate: String, trendingModels: [TrendingModel]) {
        self.init()
        self.saveDate = saveDate
        self.trendingModels.append(objectsIn: trendingModels)
    }
}

// MARK: - Category

class ArticleModel: Object {
    @Persisted var sectionName: String
    @Persisted var title: String
    @Persisted var contents: String
    @Persisted var postImage: String
    @Persisted var url: String
    @Persisted var datePublished = Date()
    @Persisted var providerName: String
        
    convenience init(sectionName: String, title: String, contents: String, postImage: String, url: String, datePublished: Date, providerName: String) {
        self.init()
        self.sectionName = sectionName
        self.title = title
        self.contents = contents
        self.postImage = postImage
        self.url = url
        self.datePublished = datePublished
        self.providerName = providerName
    }
}

class SaveArticle: Object {
    @Persisted var sectionName: String
    @Persisted var saveDate: String
    @Persisted var articleModels: List<ArticleModel>

    convenience init(sectionName: String, saveDate: String, articleModels: [ArticleModel]) {
        self.init()
        self.sectionName = sectionName
        self.saveDate = saveDate
        self.articleModels.append(objectsIn: articleModels)
    }
}

