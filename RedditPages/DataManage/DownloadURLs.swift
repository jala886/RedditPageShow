//
//  DownloadURLs.swift
//  RedditPages
//
//  Created by jianli on 3/31/22.
//

import Foundation

enum DownloadURLs{
    case redditURL
    case nextRedditURL(String)
    
    var url:String {
        switch self {
        case .redditURL:
            return "http://www.reddit.com/.json"
        case .nextRedditURL(let key):
            return DownloadURLs.redditURL.url + "?after=\(key)"
        }
    }
}
