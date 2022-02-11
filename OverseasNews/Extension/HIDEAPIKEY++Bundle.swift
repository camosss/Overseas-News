//
//  HIDEAPIKEY++Bundle.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/18.
//

import Foundation
import Alamofire

extension Bundle {
    var ApiKey: String {
        get {
            guard let filePath = self.path(forResource: "KeyInfo", ofType: "plist") else { fatalError("Couldn't find file 'KeyInfo.plist'.")}
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "API_KEY") as? String else { fatalError("Couldn't find key 'OPENWEATHERMAP_KEY' in 'KeyList.plist'.") }
            return value
        }
    }
    // HTTP 헤더 이슈 - HTTP에서 디폴드로 전달되는 헤더가 변경이 되었는디 accept-language를 지정해주고 오류 해결
    static let trendingHeaders: HTTPHeaders = ["x-rapidapi-key": Bundle.main.ApiKey]
    static let categoryHeaders: HTTPHeaders = ["accept-language": "en-US",
                                               "x-rapidapi-key": Bundle.main.ApiKey]
    static let searchHeaders: HTTPHeaders = ["x-rapidapi-key": Bundle.main.ApiKey]
}
