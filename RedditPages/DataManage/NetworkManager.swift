//
//  NetworkManager.swift
//  RedditPages
//
//  Created by jianli on 3/31/22.
//

import Foundation
import Combine
import UIKit

protocol NetworkManagerProtocol {
    func downloadData<Model:Decodable>(_ model:Model.Type, from url:DownloadURLs)->AnyPublisher<Model,DownloadError>
    func downloadImageData(from url:String, completionHandler:@escaping (Data?)->Void)
}

class NetworkManager:NetworkManagerProtocol{
    func downloadData<Model:Decodable>(_ model:Model.Type, from url:DownloadURLs)->AnyPublisher<Model,DownloadError>{
        guard let url = URL(string:url.url)
        else {return Fail<Model,DownloadError>(error:.badURL).eraseToAnyPublisher()}
        
        return URLSession.shared.dataTaskPublisher(for: url)
                .mapError {DownloadError.downloadFail($0)}
                .map{$0.data}
                .decode(type: Model.self, decoder: JSONDecoder())
                .mapError{DownloadError.decodeFail($0)}
                .eraseToAnyPublisher()
                
    }
    func downloadImageData(from url:String, completionHandler:@escaping (Data?)->Void){
        guard let url = URL(string:url)
        else{return}
        
        URLSession.shared.dataTask(with:url){data,res,e in
            completionHandler(data)
        }.resume()
    }
}
