//
//  Post.swift
//  RedditClient
//
//  Created by Gastón Funes on 06/05/2020.
//  Copyright © 2020 Gaston Funes. All rights reserved.
//

import Foundation

struct Post {
    var id: String
    var subreddit: String?
    var title: String?
    var author: String?
    var thumbnail: String?
    var numComments: Int?
    var created: Date?
    var ups: Int?
    var read: Bool
}

extension Post: Codable {
    init?(json: JSON) {
        // If the Post entity doesn't have
        // an id, the we discard it
        guard let id = json["id"] as? String else {
            return nil
        }
        
        // Parse usual Reddit posts values
        self.id = id
        self.subreddit = json["subreddit_name_prefixed"] as? String
        self.title = json["title"] as? String
        self.author = json["author"] as? String
        
        // We check if the post has a thumbnail
        if let imageThumb = json["thumbnail"] as? String {
            // If it does we check for the 'nsfw' case
            // were we just get this string and not a url
            if imageThumb.caseInsensitiveCompare("nsfw") != ComparisonResult.orderedSame {
                self.thumbnail = imageThumb
            }
        }
        
        self.numComments = json["num_comments"] as? Int
        self.ups = json["ups"] as? Int
        self.read = false
        
        // We first get the creation timestamp from the JSON object
        let creationTimestamp = json["created_utc"] as? Double
        // We then calculate the posts creation date from
        // the timestamp using the Date class
        self.created = Date(timeIntervalSince1970: creationTimestamp ?? 0)
    }
    
    func setRead(read: Bool) -> Post {
        var updatedPost = self
        updatedPost.read = read
        
        return updatedPost
    }
}
