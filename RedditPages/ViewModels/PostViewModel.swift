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
    
    func getPostData(by row:Int) -> PostModel?
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
    
    //private let downloader:NetworkManagerProtocol
    private let repository:RepositoryProtocol
    
    //    init(downloader:NetworkManager){
    //        self.downloader = downloader
    //    }
    init(repository:RepositoryProtocol){
        self.repository = repository
    }
    func loadPost(){
        getPostData(from: DownloadURLs.redditURL)
    }
    func loadMorePost() {
        getPostData(from:DownloadURLs.nextRedditURL(afterKey))
        //print(DownloadURLs.nextRedditURL(afterKey).url)
    }
    func getPostData(from url:DownloadURLs, forceUpdate:Bool=false){
        guard !isLoading else{return}
        isLoading = true
        repository.getPostData(from: url){ [weak self] result in
            switch result{
            case .success(let tuple):
                self?.afterKey = tuple.1
                if forceUpdate{
                    self?.postData = tuple.0
                    self?.repository.removeAllData()
                }else{
                    self?.postData.append(contentsOf: tuple.0)
                }
                self?.downloadImages()
                self?.repository.savePostData(tuple.0)
                self?.isLoading = false
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
        
        
        /*
         downloader.downloadData(RootModel.self, from: url)
         .breakpointOnError()
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
         }else{
         self.postData.append(contentsOf:data)
         }
         self.downloadImages()
         self.afterKey = rootModel.data.after
         self.isLoading = false
         }
         }
         .store(in: &subscribers)
         */
        
    }
    
    private func downloadImages(){
        var tempData = [Int:Data]()
        let group = DispatchGroup()
        for (index,post) in postData.enumerated(){
            if let thumbnail = post.thumbnail,thumbnail.starts(with: "https://"){
                //print(thumbnail)
                group.enter()
                //print(thumbnail)
                repository.getImageData(from: thumbnail){ result in
                    //print(result)
                    switch result{
                    case .success(let data):
                        tempData[index] = data
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    group.leave()
                }
            }
        }
        //self.imageData = tempData
        group.notify(queue: .main){ [weak self] in
            //print("update image data",self?.imageData.count,self?.postData.count)
            self?.imageData = tempData
        }
    }
    
    func forceUpdate() {
        postData = []
        imageData = [:]
        repository.removeAllData()
        getPostData(from:DownloadURLs.redditURL,forceUpdate: true)
    }
    
    func deleteData(row: Int) {
        postData.remove(at: row)
        downloadImages()
        //        imageData.remove(at: row)
        //        if imageData[row] != nil{
        //            imageData.removeValue(forKey: row)
        //        }
    }
    
    func getPostData(by row: Int) -> PostModel? {
        guard row < postData.count else { return nil }
        return postData[row]
    }
}
