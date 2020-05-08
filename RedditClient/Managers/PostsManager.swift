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
    func loadTopPosts(fromSubreddit: String, afterItem: String?, preferCache: Bool, completion: @escaping ([Post]?, ServiceError?) -> ()) -> URLSessionDataTask? {
        // If we want data from the cache
        // and there is already a saved file
        if preferCache && StorageManager.fileExists(self.storageFileName, in: .documents) {
            let postsFromDisk = self.loadPostsFromDisk()
            
            self.storedPosts = postsFromDisk
            
            completion(postsFromDisk, nil)
            
            return nil
        }
    
        // We set the parameter raw_json
        // so the Reddit API doesn't
        // HTML escape any characters
        // Count: ammount of posts we want
        // After: last item id we have
        var params: JSON = ["raw_json": 1, "limit": 10]
        
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
            
            self.storedPosts!.append(contentsOf: postsResponse!)
            
            completion(postsResponse, error)
        }
    }
    
    private func savePostsToDisk() {
        StorageManager.store(self.storedPosts, to: .documents, as: self.storageFileName)
    }
    private func loadPostsFromDisk() -> [Post] {
        return StorageManager.retrieve(storageFileName, from: .documents, as: [Post].self)
    }
    
    func getPostById(id: String) -> Post? {
        return self.storedPosts!.filter({ $0.id == id }).first
    }
    
    func setReadForPost(post: Post) -> Post? {
        if let index = self.storedPosts!.firstIndex(where: { $0.id == post.id }) {
            let updatedPost = post.setRead(read: true)
            self.storedPosts![index] = updatedPost
            self.savePostsToDisk()
            
            return updatedPost
        }
        
        return nil
    }
}
