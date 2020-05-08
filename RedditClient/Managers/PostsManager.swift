//
//  PostsManager.swift
//  RedditClient
//
//  Created by Gastón Funes on 06/05/2020.
//  Copyright © 2020 Gaston Funes. All rights reserved.
//

import Foundation

class PostsManager {
    private let client = ApiManager()
    private let storageFileName = "posts.json"
    var storedPosts: [Post]? = []
    
    @discardableResult
    func loadTopPosts(fromSubreddit: String, afterItem: String?, limit: Int?, preferCache: Bool, completion: @escaping ([Post]?, ServiceError?) -> ()) -> URLSessionDataTask? {
        // If we want data from the cache
        // and there is already a saved file
        if preferCache && StorageManager.fileExists(storageFileName, in: .documents) {
            let postsFromDisk = loadPostsFromDisk()
            
            storedPosts = postsFromDisk
            
            completion(postsFromDisk, nil)
            
            return nil
        }
    
        // raw_json: no HTML escape on characters
        // count: amount of posts we want
        // after: last item id we have
        var params: JSON = ["raw_json": 1, "limit": limit ?? 15]
        
        if let afterId = afterItem {
            params["after"] = afterId
        }
        
        // Ask our ApiManager for the top posts
        // of the subreddit we selected
        return client.load(path: "/r/" + fromSubreddit + "/top.json", method: .get, params: params) { result, error in
            let response = result as? JSON
            let responseData = response?["data"] as? JSON
            let postsData = responseData?["children"] as? nestedJSON
            let postsResponse = postsData?.compactMap{ item in Post(json: item["data"] as! JSON)}
            
            completion(postsResponse, error)
            
            self.storedPosts?.append(contentsOf: postsResponse!)
            
            DispatchQueue.main.async { [weak self] in
                self?.savePostsToDisk()
            }
        }
    }
    
    private func savePostsToDisk() {
        StorageManager.store(storedPosts, to: .documents, as: storageFileName)
    }
    private func loadPostsFromDisk() -> [Post] {
        return StorageManager.retrieve(storageFileName, from: .documents, as: [Post].self)
    }
    
    private func getIndexOfPost(post: Post) -> Int? {
        return storedPosts!.firstIndex(where: { $0.id == post.id })
    }
    func setReadForPost(post: Post) -> Post? {
        if let index = getIndexOfPost(post: post) {
            let updatedPost = post.setRead(read: true)
            storedPosts![index] = updatedPost
            savePostsToDisk()
            
            return updatedPost
        }
        
        return nil
    }
    func removePost(post: Post) {
        if let index = getIndexOfPost(post: post) {
            storedPosts!.remove(at: index)
        }
    }
}
