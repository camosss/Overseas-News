//
//  Search.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/21.
//

import Foundation

struct Search {
    let category: String // json["articles"][idx]["topic"]
    let title: String // json["articles"][idx]["title"]
    let description: String // json["articles"][idx]["summary"]
    let postImage: String // json["articles"][idx]["media"]
    let url: String // json["articles"][idx]["link"]
    let datePublished: String // json["articles"][idx]["published_date"]
    let providerName: String // json["articles"][idx]["author"]
}
