//
//  SceneDelegate.swift
//  RedditClient
//
//  Created by Gastón Funes on 06/05/2020.
//  Copyright © 2020 Gaston Funes. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard
        let splitViewController = window?.rootViewController as? UISplitViewController,
        let leftNavController = splitViewController.viewControllers.first
          as? UINavigationController,
        let masterViewController = leftNavController.viewControllers.first
          as? FeedTableViewController,
        let detailViewController = splitViewController.viewControllers.last
          as? PostDetailViewController
        else { fatalError() }

        masterViewController.delegate = detailViewController
    }
}
