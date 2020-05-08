//
//  PostCell.swift
//  RedditClient
//
//  Created by Gastón Funes on 07/05/2020.
//  Copyright © 2020 Gaston Funes. All rights reserved.
//

import Foundation
import UIKit

final class PostCell: UITableViewCell {
    @IBOutlet weak var unreadView: UIView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var commentsLabel: UILabel!
    
    var postItem: Post? {
      didSet {
        refreshUI()
      }
    }
    
    private func refreshUI() {
        if let postItem = postItem as Post? {
            unreadView.isHidden = postItem.read
            
            let postCreatedAt = "(" + (postItem.created?.timeAgoString())! + ")"
            let postAuthor = "u/" + postItem.author!
            authorLabel.text = postAuthor + " " + postCreatedAt
            
            articleImage.loadFromURL(imageUrl: postItem.thumbnail!)
            titleLabel.text = postItem.title
            commentsLabel.text = postItem.numComments!.description + " comments"
        }
    }
}
