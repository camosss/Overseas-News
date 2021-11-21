//
//  RealmModel.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/21.
//

import Foundation
import RealmSwift

class RealmModel: Object {
    @Persisted var title: String
    @Persisted var contents: String
    @Persisted var postImage: String
    @Persisted var url: String
    @Persisted var datePublished: String
    @Persisted var providerName: String
    @Persisted var providerImage: String
    @Persisted var scrap: Bool
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(title: String, contents: String, postImage: String, url: String, datePublished: String, providerName: String, providerImage: String) {
        self.init()
        self.title = title
        self.contents = contents
        self.postImage = postImage
        self.url = url
        self.datePublished = datePublished
        self.providerName = providerName
        self.providerImage = providerImage
        self.scrap = false
    }
}
