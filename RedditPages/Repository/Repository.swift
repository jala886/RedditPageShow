//
//  Repository.swift
//  RedditPages
//
//  Created by jianli on 4/5/22.
//

import Foundation




class Repository:RepositoryProtocol{
    let remote:RemoteRepoProtocol
    let local:LocalRepoProtocol
    
    init(remote:RemoteRepoProtocol, local:LocalRepoProtocol){
        self.remote = remote
        self.local = local
    }
    func getPostData(from url: DownloadURLs, _ completionHandler: @escaping (Result<SuccessResponse, DownloadError>) -> Void) {
        remote.getPostData(from: url, completionHandler)
    }
    func getImageData(from url:String, completionHandler: @escaping (Result<Data, DownloadError>) -> Void) {
        remote.getImageData(from: url, completionHandler: completionHandler)
    }
    func getPostData() -> [PostModel] {
        local.getPostData()
    }
    func savePostData(_ postData: [PostModel]) {
        local.savePostData(postData)
    }
    func removeAllData() {
        local.removeAllData()
    }
}
