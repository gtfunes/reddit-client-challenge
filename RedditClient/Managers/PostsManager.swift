//
//  PostsManager.swift
//  RedditClient
//
//  Created by Gastón Funes on 06/05/2020.
//  Copyright © 2020 Gaston Funes. All rights reserved.
//

import Foundation

final class PostsManager {
    private let client = ApiManager()
    
    @discardableResult
    func loadTopPosts(completion: @escaping ([Post]?, ServiceError?) -> ()) -> URLSessionDataTask? {
        // We don't need to pass any parameters
        // for this request
        let params: JSON = [:]
        
        // Ask our ApiManager for the top posts
        // of the r/worldnews subreddit
        return client.load(path: "/r/worldnews/top.json", method: .get, params: params) { result, error in
            let response = result as? JSON
            let responseData = response?["data"] as? JSON
            let postsData = responseData?["children"] as? nestedJSON
            let postsResponse = postsData?.compactMap{ item in Post(json: item["data"] as! JSON)}
            
            completion(postsResponse, error)
        }
    }
}
