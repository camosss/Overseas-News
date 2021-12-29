//
//  URL+Extension.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/12/15.
//

import Foundation

extension URL {
    static func trendingURL() -> String {
        return "https://contextualwebsearch-websearch-v1.p.rapidapi.com/api/search/TrendingNewsAPI?pageNumber=1&pageSize=10&withThumbnails=false&location=us"
    }
    
    static func searchURL(searchText: String) -> String {
        return "https://free-news.p.rapidapi.com/v1/search?q=\(searchText)&lang=en"
    }
    
    static func categoryURL(urlString: String) -> String {
        return "https://bing-news-search1.p.rapidapi.com/news?category=\(urlString)&cc=US&safeSearch=Off&textFormat=Raw"
    }
}
