//
//  FeedTableViewController.swift
//  RedditClient
//
//  Created by Gastón Funes on 06/05/2020.
//  Copyright © 2020 Gaston Funes. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    var postsTask: URLSessionDataTask! = nil
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Top in r/worldnews"

        postsTask = PostsManager().loadTopPosts(completion: { (remotePosts, error) in
            if let error = error as ServiceError? {
                print(error.localizedDescription)
            } else if let remotePosts = remotePosts as [Post]? {
                print(remotePosts)
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
     
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // If out tableView does not have
        // a footer view, then it won't repeat
        // separators after the last cell
        let footerView = UIView.init()
        footerView.backgroundColor = UIColor.clear
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
