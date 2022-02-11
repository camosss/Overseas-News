//
//  APIService.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/12/28.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIService {
    static let shared = APIService()
    
    func requestSearch(url: String, completion: @escaping ([Search]?, Error?) -> ()) {
        AF.request(url, method: .get, headers: Bundle.searchHeaders).validate().responseJSON { response in
            var tmp = [Search]()
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for idx in 0..<json["articles"].count {
                    let category = "\(json["articles"][idx]["topic"])"
                    let title = "\(json["articles"][idx]["title"])"
                    let description = "\(json["articles"][idx]["summary"])"
                    let postImage = "\(json["articles"][idx]["media"])"
                    let url = "\(json["articles"][idx]["link"])"
                    let datePublished = "\(json["articles"][idx]["published_date"])"
                    let providerName = "\(json["articles"][idx]["author"])"
                    
                    tmp.append(Search(category: category, title: title, description: description, postImage: postImage, url: url, datePublished: datePublished, providerName: providerName))
                }
                completion(tmp, nil)
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func requestTrending(completion: @escaping ([TrendingModel]) -> ()) {
        AF.request(URL.trendingURL(), method: .get, headers: Bundle.trendingHeaders).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var tempTrendingTopic: [TrendingModel] = []
                
                for idx in 0..<json["value"].count {
                    let title = "\(json["value"][idx]["title"])"
                    let snippet = "\(json["value"][idx]["snippet"])"
                    let postImage = "\(json["value"][idx]["image"]["url"])"
                    let url = "\(json["value"][idx]["url"])"
                    let provider = "\(json["value"][idx]["provider"]["name"])"
                    
                    let datePublished = "\(json["value"][idx]["datePublished"])"
                    let endIndex: String.Index = datePublished.index(datePublished.startIndex, offsetBy: 18)
                    let datePublish = String(datePublished[...endIndex])
                    
                    let trendingTopic = TrendingModel(title: title, snippet: snippet, postImage: postImage, url: url, datePublished: datePublished.toDate(stringValue: datePublish) ?? Date(), provider: provider)
                    tempTrendingTopic.append(trendingTopic)
                }
                completion(tempTrendingTopic)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestCategory(urlString: String, completion: @escaping ([ArticleModel]) -> ()) {
        AF.request(URL.categoryURL(urlString: urlString), method: .get, headers: Bundle.categoryHeaders).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var tempArticle: [ArticleModel] = []

                for idx in 0..<json["value"].count {
                    let title = "\(json["value"][idx]["name"])"
                    let description = "\(json["value"][idx]["description"])"
                    let postImage = "\(json["value"][idx]["image"]["thumbnail"]["contentUrl"])"
                    let url = "\(json["value"][idx]["url"])"
                    let providerName = "\(json["value"][idx]["provider"][0]["name"])"
                    
                    let datePublished = "\(json["value"][idx]["datePublished"])"
                    let endIndex: String.Index = datePublished.index(datePublished.startIndex, offsetBy: 18)
                    let datePublish = String(datePublished[...endIndex])
                    
                    let articles = ArticleModel(sectionName: urlString, title: title, contents: description, postImage: postImage, url: url, datePublished: datePublished.toDate(stringValue: datePublish) ?? Date(), providerName: providerName)
                    tempArticle.append(articles)
                }
                completion(tempArticle)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
