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
    //var imagePublisher:Published<[Int:Data]>.Publisher {get}
    var imagePublisher:Published<[Data?]>.Publisher {get}
    //var imageData:[Int:Data] {get}
    var imageData:[Data?] {get}
    
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
    //@Published private(set) var imageData:[Int:Data] = [:]
    //var imagePublisher:Published<[Int:Data]>.Publisher{$imageData}
    @Published private(set) var imageData = [Data?]()
    var imagePublisher:Published<[Data?]>.Publisher{$imageData}
    
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
        getPostData(from:DownloadURLs.nextRedditURL(afterKey), forceUpdate:true)
        //print(DownloadURLs.nextRedditURL(afterKey).url)
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
                print(#function,error.localizedDescription)
                //abort()
            }
            } receiveValue: { [weak self] rootModel in
                if let self = self{
                    let data = rootModel.data.children.map{$0.data}
                    if forceUpdate {
                        self.postData = data
                        //self.imageData = self.loadImages(data)
                    }else{
                        self.postData.append(contentsOf:data)
                        //self.imageData.append(selfloadImages(data))
                    }
                    self.downloadImages()
                    self.afterKey = rootModel.data.after
                    self.isLoading = false
                }
            }
            .store(in: &subscribers)
        
    }
    private func downloadImages(){
        //var imageData = [Data?]()
        var tempData = [Data?]()
        let group = DispatchGroup()
        for post in postData{
            if let thumbnail = post.thumbnail{
                //print(thumbnail)
                if thumbnail.starts(with: "https://"){
                    group.enter()
                    //print(thumbnail)
                    downloader.downloadImageData(from: thumbnail){
                        tempData.append($0)
                        group.leave()
                    }
                    
                }else{
                    tempData.append(nil)
                }
            }
        }

        //self.imageData = tempData
        group.notify(queue: .main){ [weak self] in
            print("update image data",self?.imageData.count,self?.postData.count)
            self?.imageData = tempData
        }
    }
    
    func forceUpdate() {
        getPostData(from:DownloadURLs.redditURL,forceUpdate: true)
    }
    
    func deleteData(row: Int) {
        postData.remove(at: row)
        imageData.remove(at: row)
//        if imageData[row] != nil{
//            imageData.removeValue(forKey: row)
//        }
    }
}
