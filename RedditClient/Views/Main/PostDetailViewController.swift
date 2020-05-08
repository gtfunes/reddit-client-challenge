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
    
    var longPressRecognizer: UILongPressGestureRecognizer? = nil
    
    var postItem: Post? {
      didSet {
        if isViewLoaded {
            refreshUI()
        }
      }
    }
    
    @objc private func longPressOnImage(sender: UILongPressGestureRecognizer) {
        // We check if we are not already presenting
        // a view controller and if the gesture is in
        // the 'ended' state (to avoid calling multiple times)
        if self.presentingViewController == nil && sender.state == UIGestureRecognizer.State.ended {
            // Show a UIActivityViewController
            // with the current post's image
            let activityItem: [AnyObject] = [articleImage.image as AnyObject]
            let shareSheet = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: [])
            shareSheet.popoverPresentationController?.sourceView = self.articleImage
            present(shareSheet, animated: true, completion: nil)
        }
    }
    
    private func refreshUI() {
        if let postItem = postItem as Post? {
            // In this example we use the default
            // Reddit profile picture here as the user's
            // info does not come in the json we use
            userImage.isHidden = false
            userImage.loadFromURL(imageUrl: "https://www.redditstatic.com/avatars/avatar_default_19_0DD3BB.png", completion: { data in
                DispatchQueue.main.async { [weak self] in
                    self?.userImage.image = UIImage(data: data!)
                }
            })
            
            authorLabel.isHidden = false
            let postCreatedAt = "(" + (postItem.created?.timeAgoString())! + ")"
            let postAuthor = "u/" + postItem.author!
            authorLabel.text = postAuthor + " " + postCreatedAt
            
            articleImage.image = nil
            
            if let postImage = postItem.thumbnail as String? {
                if postImage.count > 0 {
                    articleImage.isHidden = false
                    articleImage.loadFromURL(imageUrl: postImage, completion: { data in
                        DispatchQueue.main.async { [weak self] in
                            self?.articleImage.image = UIImage(data: data!)
                        }
                    })
                    
                    if longPressRecognizer == nil {
                        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressOnImage))
                        longPressRecognizer?.minimumPressDuration = 0.2
                        articleImage.addGestureRecognizer(longPressRecognizer!)
                    }
                } else {
                    articleImage.isHidden = true
                }
            } else {
                articleImage.isHidden = true
            }
            
            titleLabel.isHidden = false
            titleLabel.text = postItem.title
        } else {
            userImage?.isHidden = true
            authorLabel?.isHidden = true
            articleImage?.isHidden = true
            titleLabel?.isHidden = true
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
