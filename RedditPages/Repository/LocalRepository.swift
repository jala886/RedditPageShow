//
//  LocalRepository.swift
//  RedditPages
//
//  Created by jianli on 4/5/22.
//

import Foundation
import CoreData

class LocalRepository:LocalRepoProtocol{
    private lazy var persistentContainer:NSPersistentContainer = {
        let container = NSPersistentContainer(name:"CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    private lazy var context = persistentContainer.viewContext

    
    func getPostData() -> [PostModel] {
        let request:NSFetchRequest = CDPost.fetchRequest()
        do{
            let posts = try context.fetch(request)
            return posts.map{
                PostModel(
                    title: $0.title,
                    thumbnail: $0.thumbnail,
                    score:Int($0.score),
                    numComments: Int($0.numComments),
                    author: $0.author,
                    ups:Int($0.ups)
                )
            }
        }catch(let error){
            print(error.localizedDescription)
            return []
        }
    }
    
    func savePostData(_ postDatas: [PostModel]) {
        guard let entityDesc = NSEntityDescription.entity(forEntityName:"CDPost", in: context)
        else {return}
        for postData in postDatas{
            let cdPost = CDPost(entity:entityDesc, insertInto:context)
            cdPost.title = postData.title
        }
        do {
            try context.save()
        }catch (let error){
            print(error.localizedDescription)
        }
    }
    
    func removeAllData() {
        let request:NSFetchRequest = CDPost.fetchRequest()
        do{
            let posts = try context.fetch(request)
            for post in posts{
                context.delete(post)
            }
            try context.save()
        }catch(let error){
            print(error.localizedDescription)
        }
    }
}
