//
//  DownloadError.swift
//  RedditPages
//
//  Created by jianli on 3/31/22.
//

import Foundation


enum DownloadError:Error{
    case badURL
    case downloadFail(Error)
    case decodeFail(Error)
}
