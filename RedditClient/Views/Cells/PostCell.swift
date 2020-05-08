//
//  PostCell.swift
//  RedditClient
//
//  Created by Gastón Funes on 07/05/2020.
//  Copyright © 2020 Gaston Funes. All rights reserved.
//

import Foundation
import UIKit

protocol PostCellDelegate: class {
  func shouldDismissPost(_ postToDismiss: Post)
}

final class PostCell: UITableViewCell {
    @IBOutlet weak var unreadView: UIView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var commentsLabel: UILabel!
    
    weak var delegate: PostCellDelegate?
    
    var postItem: Post? {
      didSet {
        refreshUI()
      }
    }
    
    @objc private func onDismissTapped() {
        self.delegate?.shouldDismissPost(self.postItem!)
    }
    
    private func refreshUI() {
        if let postItem = postItem as Post? {
            unreadView.isHidden = postItem.read
            
            let postCreatedAt = "(" + (postItem.created?.timeAgoString())! + ")"
            let postAuthor = "u/" + postItem.author!
            authorLabel.text = postAuthor + " " + postCreatedAt
            
            if let postImage = postItem.thumbnail as String? {
                if postImage.count > 0 {
                    articleImage.isHidden = false
                    articleImage.loadFromURL(imageUrl: postImage, completion: { data in
                        DispatchQueue.main.async { [weak self] in
                            // We check if the url that we fetched
                            // is the same as the one in the cell
                            // because they get reused
                            if postImage as AnyObject === self?.postItem?.thumbnail as AnyObject? {
                                self?.articleImage.image = UIImage(data: data!)
                            }
                        }
                    })
                } else {
                    articleImage.isHidden = true
                }
            } else {
                articleImage.isHidden = true
            }
            
            titleLabel.text = postItem.title
            
            dismissButton.addTarget(self, action: #selector(self.onDismissTapped), for: .touchUpInside)
            
            commentsLabel.text = postItem.numComments!.description + " comments"
        }
    }
}
