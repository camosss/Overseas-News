//
//  URL+Extension.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/12/15.
//

import Foundation

extension URL {
    static func trendingURL() -> URL {
        return URL(string: "https://contextualwebsearch-websearch-v1.p.rapidapi.com/api/search/TrendingNewsAPI?pageNumber=1&pageSize=10&withThumbnails=false&location=us")!
    }
    
    static func searchURL(searchText: String) -> URL {
        return URL(string: "https://free-news.p.rapidapi.com/v1/search?q=\(searchText)&lang=en")!
    }
    
    static func categoryURL(urlString: String) -> URL {
        return URL(string: "https://bing-news-search1.p.rapidapi.com/news?category=\(urlString)&cc=US&safeSearch=Off&textFormat=Raw")!
    }
}
