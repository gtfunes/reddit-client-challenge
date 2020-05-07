//
//  GlobalSpliViewController.swift
//  RedditClient
//
//  Created by Gastón Funes on 07/05/2020.
//  Copyright © 2020 Gaston Funes. All rights reserved.
//

import UIKit

class GlobalSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        // We set the preferredDisplayMode
        // property here to avoid showing the detail
        // view first when in collapsed mode (portrait)
        self.preferredDisplayMode = .allVisible
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        // Return true to prevent UIKit from applying its default behavior
        return true
    }
}
