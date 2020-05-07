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
            //image
            authorLabel.text = "u/" + postItem.author!
            //image
            titleLabel.text = postItem.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Post detail"
        
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

