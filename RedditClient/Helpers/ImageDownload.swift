//
//  ImageDownload.swift
//  RedditClient
//
//  Created by Gastón Funes on 07/05/2020.
//  Copyright © 2020 Gaston Funes. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadFromURL(imageUrl: String) {
        let request = URLRequest(baseUrl: imageUrl, path: "", method: RequestMethod.get, params: [:]);
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { [weak self] in
                if let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode {
                    self?.image = UIImage(data: data!)
                }
            }
        }
        
        task.resume()
    }
}
