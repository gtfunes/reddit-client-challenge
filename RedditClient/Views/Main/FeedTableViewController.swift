//
//  FeedTableViewController.swift
//  RedditClient
//
//  Created by Gastón Funes on 06/05/2020.
//  Copyright © 2020 Gaston Funes. All rights reserved.
//

import Foundation
import UIKit

protocol PostSelectionDelegate: class {
  func postSelected(_ newPost: Post)
}

class FeedTableViewController: UITableViewController {
    var subreddit: String = "gaming"
    
    var isLoading: Bool = false
    var pageSize: Int = 15
    var totalPostsSize: Int = 50
    
    var postsManager: PostsManager = PostsManager.init()
    var postsTask: URLSessionDataTask! = nil
    var selectedPost: Post? = nil
    
    var cellIdentifier: String = "PostCell"
    
    weak var delegate: PostSelectionDelegate?
    
    private func loadTopPosts(preferCache: Bool) {
        isLoading = true
        
        var lastId: String? = nil
        
        if self.postsManager.storedPosts!.count > 0 {
            let lastItem = self.postsManager.storedPosts!.last
            lastId =  "t3_" + lastItem!.id
        }
        
        postsTask?.cancel()
        postsTask = self.postsManager.loadTopPosts(fromSubreddit: subreddit, afterItem: lastId, preferCache: preferCache, completion: { (remotePosts, error) in
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
                
                if let error = error as ServiceError? {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

                    self?.present(alert, animated: true)
                } else if let remotePosts = remotePosts as [Post]? {
                    self?.tableView.reloadData()
                    
                    if !(self?.splitViewController!.isCollapsed)! && remotePosts.count > 0 {
                        self?.setSelectedPost(selectedPost: remotePosts.first!)
                    }
                }
            }
        })
    }
    private func setSelectedPost(selectedPost: Post) {
        let updatedPost = self.postsManager.setReadForPost(post: selectedPost)
        self.selectedPost = updatedPost
        
        if let detailViewController = delegate as? PostDetailViewController {
            if splitViewController!.isCollapsed as Bool {
                splitViewController?.showDetailViewController(detailViewController, sender: nil)
            }
            
            detailViewController.postItem = self.selectedPost
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Top in r/" + subreddit
        
        loadTopPosts(preferCache: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postsManager.storedPosts!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? PostCell {
            cell.postItem = self.postsManager.storedPosts![indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            
        let selectedPost = self.postsManager.storedPosts![indexPath.row]
        setSelectedPost(selectedPost: selectedPost)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // If our tableView does not have
        // a footer view, then it will repeat
        // separators after the last cell
        let footerView = UIView.init()
        footerView.backgroundColor = UIColor.clear
        
        return footerView
    }
}
