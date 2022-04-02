//
//  Cache.swift
//  RedditPages
//
//  Created by jianli on 3/31/22.
//

import Foundation


class Cache{
    static let KeyName = "postData"
    static func get(postViewModel:PostViewModel)-> CacheModel?{
        if let data = UserDefaults.standard.data(forKey: Cache.KeyName){
            if let decodeData = try? JSONDecoder().decode(CacheModel.self, from: data){
                return decodeData
            }
        }
        return nil
    }
    static func set(postViewModel:PostViewModel){
        let cacheData = CacheModel(date:Date(),data:postViewModel.postData)
        let encodeData = try! JSONEncoder().encode(cacheData)
        UserDefaults.standard.set(encodeData, forKey: Cache.KeyName )
        NSLog("save data input defaults with name postData")
    }
}
