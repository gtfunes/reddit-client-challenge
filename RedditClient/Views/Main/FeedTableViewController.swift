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
    private var subreddit: String = "gaming"
    private var pageSize: Int = 15
    private var posts: [Post] = []
    
    private var postsManager: PostsManager = PostsManager.init()
    private var postsTask: URLSessionDataTask! = nil
    private var selectedPost: Post? = nil
    
    private var isLoading: Bool = false
    private var cellSize: CGFloat = 150
    private var cellIdentifier: String = "PostCell"
    
    weak var delegate: PostSelectionDelegate?
    
    private func loadTopPosts(preferCache: Bool, fullRefresh: Bool) {
        if self.isLoading {
            return
        }
        
        self.isLoading = true
        self.refreshControl?.beginRefreshing()
        
        var lastId: String? = nil
        
        if fullRefresh == false && self.posts.count > 0 {
            let lastItem = self.posts.last
            lastId =  "t3_" + lastItem!.id
        }
        
        postsTask?.cancel()
        postsTask = self.postsManager.loadTopPosts(fromSubreddit: subreddit, afterItem: lastId, limit: pageSize, preferCache: preferCache, completion: { (remotePosts, error) in
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
                self?.refreshControl?.endRefreshing()
                
                if let error = error as ServiceError? {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

                    self?.present(alert, animated: true)
                } else if let remotePosts = remotePosts as [Post]? {
                    if lastId == nil || fullRefresh {
                        self?.posts = remotePosts
                    } else {
                        self?.posts.append(contentsOf: remotePosts)
                    }
                    
                    self?.tableView.reloadData()
                    
                    if !(self?.splitViewController!.isCollapsed)! && remotePosts.count > 0 {
                        self?.setSelectedPost(selectedPost: remotePosts.first!)
                    }
                }
            }
        })
    }
    private func loadTopPostsFromCache() {
        loadTopPosts(preferCache: true, fullRefresh: true)
    }
    @objc private func loadTopPostsFromServer() {
        loadTopPosts(preferCache: false, fullRefresh: true)
    }
    private func loadMoreTopPosts() {
        loadTopPosts(preferCache: false, fullRefresh: false)
    }
    
    private func setSelectedPost(selectedPost: Post) {
        let updatedPost = self.postsManager.setReadForPost(post: selectedPost)
        self.selectedPost = updatedPost
        
        let postIndex = self.posts.firstIndex(where: { $0.id == selectedPost.id })
        self.posts[postIndex!] = self.selectedPost!
        
        if let detailViewController = delegate as? PostDetailViewController {
            if splitViewController!.isCollapsed as Bool {
                splitViewController?.showDetailViewController(detailViewController, sender: nil)
            }
            
            detailViewController.postItem = self.selectedPost
        }
    }
    private func dismissPost(postToDismiss: Post) {
        self.postsManager.removePost(post: postToDismiss)
        
        let postIndex = self.posts.firstIndex(where: { $0.id == postToDismiss.id })
        self.posts.remove(at: postIndex!)
        self.tableView.deleteRows(at: [IndexPath.init(row: postIndex!, section: 0)], with: .fade)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Top in r/" + subreddit
        
        loadTopPostsFromCache()
        
        self.refreshControl?.addTarget(self, action: #selector(loadTopPostsFromServer), for: UIControl.Event.valueChanged)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? PostCell {
            cell.postItem = self.posts[indexPath.row]
            cell.delegate = self
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            
        let selectedPost = self.posts[indexPath.row]
        setSelectedPost(selectedPost: selectedPost)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellSize
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

extension FeedTableViewController: PostCellDelegate {
  func shouldDismissPost(_ postToDismiss: Post) {
    self.dismissPost(postToDismiss: postToDismiss)
  }
}
