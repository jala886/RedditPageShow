//
//  RepositoryProtoloc.swift
//  RedditPages
//
//  Created by jianli on 4/5/22.
//

import Foundation

protocol RepositoryProtocol:RemoteRepoProtocol, LocalRepoProtocol{
    var remote: RemoteRepoProtocol {get}
    var local:LocalRepoProtocol {get}
}

typealias SuccessResponse = ([PostModel],String)
protocol RemoteRepoProtocol{
    func getPostData(from url:DownloadURLs,_ completionHandler: @escaping (Result<SuccessResponse,DownloadError>)->Void)
    func getImageData(from url:String, completionHandler:@escaping (Result<Data,DownloadError>)->Void)
}

protocol LocalRepoProtocol {
    func getPostData()->[PostModel]
    func savePostData(_ postData:[PostModel])
    func removeAllData()
}
