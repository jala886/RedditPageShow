//
//  CacheModel.swift
//  RedditPages
//
//  Created by jianli on 3/31/22.
//

import Foundation

struct CacheModel:Codable{
    let date:Date
    let data:[PostModel]
}
