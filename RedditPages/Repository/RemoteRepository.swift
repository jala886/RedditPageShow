//
//  RemoteRepository.swift
//  RedditPages
//
//  Created by jianli on 4/5/22.
//

import Foundation
import Combine

class RemoteRepository: RemoteRepoProtocol{
    private let networkManager:NetworkManager
    private var subscribes = Set<AnyCancellable>()
    
    init (networkManager:NetworkManager){
        self.networkManager = networkManager
    }
    
    func getPostData(from url: DownloadURLs, _ completionHandler: @escaping (Result<SuccessResponse, DownloadError>) -> Void) {
            networkManager
            .downloadData(RootModel.self, from: url)
                .sink { _ in } receiveValue: { response in
                    let afterKey = response.data.after
                    let posts = response.data.children.map { $0.data }
                    completionHandler(.success((posts, afterKey)))
                }
                .store(in: &subscribes)
        }
        
        func getImageData(from url: String, completionHandler: @escaping (Result<Data, DownloadError>) -> Void) {
            networkManager.downloadImageData(from: url) { data in
                if let data = data {
                    completionHandler(.success(data))
                } else {
                    completionHandler(.failure(.badURL))
                }
            }
        }
}
