//
//  DownloadURLs.swift
//  RedditPages
//
//  Created by jianli on 3/31/22.
//

import Foundation

enum DownloadURLs:String{
    case redditURL
    case nextRedditURL
    
    var url:String {
        switch self {
        case .redditURL:
            return "http://www.reddit.com/.json"
        case .nextRedditURL:
            return DownloadURLs.redditURL.url + "?after=+afterLink"
        }
    }
}
