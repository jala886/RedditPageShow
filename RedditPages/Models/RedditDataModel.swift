//
//  RedditDataModel.swift
//  RedditPages
//
//  Created by jianli on 3/31/22.
//

import Foundation


// struct for cascade package download data from URL
struct RootModel:Codable{
    let data:RootDataModel
}

struct RootDataModel:Codable{
    let after:String
    let children:[ChildModel]
}

struct ChildModel:Codable{
    //let kind:String
    let data:PostModel
}

// This is the final and core Data
struct PostModel:Codable{
    let title:String?
    let thumbnail:String?
    let score:Int?
    let numComments:Int?
    let author:String?
    let ups:Int?
    
    enum CodingKeys: String, CodingKey{
        case title,thumbnail, score,ups
        case numComments = "num_comments"
        case author
    }
}
