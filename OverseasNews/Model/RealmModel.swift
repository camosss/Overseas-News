//
//  RealmModel.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/21.
//

import Foundation
import RealmSwift

class ArticleModel: Object {
    @Persisted var sectionName: String
    @Persisted var title: String
    @Persisted var contents: String
    @Persisted var postImage: String
    @Persisted var url: String
    @Persisted var datePublished: String
    @Persisted var providerName: String
        
    convenience init(sectionName: String, title: String, contents: String, postImage: String, url: String, datePublished: String, providerName: String) {
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

