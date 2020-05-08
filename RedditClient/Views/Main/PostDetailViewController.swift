//
//  PostDetailViewController.swift
//  RedditClient
//
//  Created by Gastón Funes on 07/05/2020.
//  Copyright © 2020 Gaston Funes. All rights reserved.
//

import Foundation
import UIKit

class PostDetailViewController: UIViewController {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var postItem: Post? {
      didSet {
        if isViewLoaded {
            refreshUI()
        }
      }
    }
    
    private func refreshUI() {
        if let postItem = postItem as Post? {
            // In this example we use the default
            // Reddit profile picture here as the user's
            // info does not come in the json we use
            //userImage.image = nil
            userImage.loadFromURL(imageUrl: "https://www.redditstatic.com/avatars/avatar_default_19_0DD3BB.png")
            
            authorLabel.text = "u/" + postItem.author!
            
            articleImage.image = nil
            
            if let postImage = postItem.thumbnail as String? {
                articleImage.isHidden = false
                articleImage.loadFromURL(imageUrl: postImage)
            } else {
                articleImage.isHidden = true
            }
            
            titleLabel.text = postItem.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.refreshUI()
    }
}

extension PostDetailViewController: PostSelectionDelegate {
  func postSelected(_ newPost: Post) {
    postItem = newPost
  }
}
