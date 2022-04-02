//
//  PageViewModel.swift
//  RedditPages
//
//  Created by jianli on 3/31/22.
//

import Foundation
import Combine

//MARK: This is only for UIKit. For swiftUI or mix, can used @observer @publisher directly
protocol PostViewModelDelegate{
    // send update action message to View
    var postPublisher:Published<[PostModel]>.Publisher {get}
    var postData:[PostModel] {get}
    var imagePublisher:Published<[Int:Data]>.Publisher {get}
    var imageData:[Int:Data] {get}
    
    func loadPost()
    func loadMorePost()
    func forceUpdate()
    
    func deleteData(row:Int)
}

class PostViewModel: PostViewModelDelegate{
    
    var totalRows: Int { postData.count }
    // dispose any cancellable
    private var subscribers = Set<AnyCancellable>()
    
    @Published private(set) var postData = [PostModel]()
    var postPublisher:Published<[PostModel]>.Publisher{$postData}
    @Published private(set) var imageData:[Int:Data] = [:]
    var imagePublisher:Published<[Int:Data]>.Publisher{$imageData}
    
    private var afterKey = ""
    private var isLoading = false
    
    private let downloader:NetworkManagerProtocol
    
    init(downloader:NetworkManager){
        self.downloader = downloader
    }
    func loadPost(){
        getPostData(from: DownloadURLs.redditURL)
    }
    func loadMorePost() {
        getPostData(from:DownloadURLs.nextRedditURL, forceUpdate:true)
    }
    func getPostData(from url:DownloadURLs, forceUpdate:Bool=false){
        guard !isLoading else{return}
        isLoading = true
        downloader.downloadData(RootModel.self, from: url)
            .sink{ completion in
            switch completion{
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
            } receiveValue: { [weak self] rootModel in
                if let self = self{
                    let data = rootModel.data.children.map{$0.data}
                    if forceUpdate {
                        self.postData = data
                    }else{
                        self.postData.append(contentsOf: data)
                    }
                    self.downloadImages()
                    self.afterKey = rootModel.data.after
                    self.isLoading = false
                }
            }
            .store(in: &subscribers)
    }
    
    private func downloadImages(){
        var imageData = [Int:Data]()
        let group = DispatchGroup()
        for (index, post) in postData.enumerated(){
            if let thumbnail = post.thumbnail{
                group.enter()
                downloader.downloadImageData(from:thumbnail){ data in
                    if let data = data{
                        imageData[index] = data
                    }
                    group.leave()
                }
            }
        }
        group.notify(queue: .main){ [weak self] in
            self?.imageData = imageData
        }
    }
    
    func forceUpdate() {
        postData = []
        imageData = [:]
        getPostData(from:DownloadURLs.redditURL,forceUpdate: true)
    }
    
    func deleteData(row: Int) {
        postData.remove(at: row)
        if imageData[row] != nil{
            imageData.removeValue(forKey: row)
        }
    }
}
