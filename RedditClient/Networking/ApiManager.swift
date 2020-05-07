//
//  ApiManager.swift
//  RedditClient
//
//  Created by Gastón Funes on 06/05/2020.
//  Copyright © 2020 Gaston Funes. All rights reserved.
//

import Foundation

public typealias JSON = [String: Any]
public typealias nestedJSON = [[String: Any]]

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

final class ApiManager {
    private var baseUrl: String
    
    init() {
        self.baseUrl = "https://reddit.com"
    }
    
    func load(path: String, method: RequestMethod, params: JSON, completion: @escaping (Any?, ServiceError?) -> ()) -> URLSessionDataTask? {
        // We should check for an active internet connection
        // first, we are not doing that for this example
        /*if !Reachability.isConnectedToNetwork() {
            completion(nil, ServiceError.noInternetConnection)
            return nil
        }*/

        // Create URLRequest object
        let request = URLRequest(baseUrl: baseUrl, path: path, method: method, params: params)

        // Create task using URLSession
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Parse incoming data
            var object: Any? = nil
            if let data = data {
                object = try? JSONSerialization.jsonObject(with: data, options: [])
            }
            
            // In order to know if the request was successfull
            // we check whether the HTTP response
            // code is in the 200 range
            if let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode {
                completion(object, nil)
            } else {
                // If there was an error, we parse it and return it
                let error = (object as? JSON).flatMap(ServiceError.init) ?? ServiceError.other
                completion(nil, error)
            }
        }
        
        // Start task
        task.resume()
        
        return task
    }
}
