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
    var title: String?
    var author: String?
    var thumbnail: String?
    var numComments: Int?
    var created: Date?
    var ups: Int?
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
        self.title = json["title"] as? String
        self.author = json["author"] as? String
        self.thumbnail = json["thumbnail"] as? String
        self.numComments = json["num_comments"] as? Int
        self.ups = json["ups"] as? Int
        
        // We first get the creation timestamp from the JSON object
        let creationTimestamp = json["created"] as? Double
        // We then calculate the posts creation date from
        // the timestamp using the Date class
        self.created = Date(timeIntervalSince1970: creationTimestamp ?? 0)
    }
}