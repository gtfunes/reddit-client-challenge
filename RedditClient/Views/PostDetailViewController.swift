//
//  PostDetailViewController.swift
//  RedditClient
//
//  Created by Gastón Funes on 07/05/2020.
//  Copyright © 2020 Gaston Funes. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    var postItem: Post! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Post detail"
    }
}
