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
    func loadFromURL(imageUrl: String, completion: @escaping (Data?) -> ()) {
        let request = URLRequest(baseUrl: imageUrl, path: "", method: RequestMethod.get, params: [:]);
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode {
                completion(data!)
            }
        }
        
        task.resume()
    }
}
