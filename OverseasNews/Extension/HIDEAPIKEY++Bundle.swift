//
//  HIDEAPIKEY++Bundle.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/18.
//

import Foundation
import Alamofire

extension Bundle {
    var bingApiKey: String {
        get {
            guard let filePath = self.path(forResource: "KeyInfo", ofType: "plist") else { fatalError("Couldn't find file 'KeyInfo.plist'.")}
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "API_KEY") as? String else { fatalError("Couldn't find key 'OPENWEATHERMAP_KEY' in 'KeyList.plist'.") }
            return value
        }
    }
    
    static let headers: HTTPHeaders = ["x-rapidapi-host": "bing-news-search1.p.rapidapi.com",
                                       "x-rapidapi-key": Bundle.main.bingApiKey]
    
    static let searchHeaders: HTTPHeaders = ["x-rapidapi-host": "free-news.p.rapidapi.com",
                                       "x-rapidapi-key": Bundle.main.bingApiKey]

}
