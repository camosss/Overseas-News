//
//  HIDEAPIKEY++Bundle.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/18.
//

import Foundation

extension Bundle {
    var bingApiKey: String {
        get {
            guard let filePath = self.path(forResource: "BingInfo", ofType: "plist") else { fatalError("Couldn't find file 'BingInfo.plist'.")}
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "API_KEY") as? String else { fatalError("Couldn't find key 'OPENWEATHERMAP_KEY' in 'KeyList.plist'.") }
            return value
        }
    }
}
