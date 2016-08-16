//
//  APIClient.swift
//  Bikey
//
//  Created by Peter Smith on 01/02/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//

import Foundation

/**
 ### API client
 
 An API client for performing API requests
 */
struct APIClient {
    
    /**
     Perform GET requests using the specified URL
     
     - parameter url:        The URL endpoint
     - parameter completion: Completion closure expression
     */
    static func get(from url: String, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        
        if let request = clientURLRequest(url) {
            dataTask(for: request, completion: completion)
        }
    }
    
    private static func clientURLRequest(_ url: String) -> URLRequest? {
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            return request
        }
        
        return nil
    }
    
    private static func dataTask(for request: URLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: request) { (data, response, error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) , let response = response as? HTTPURLResponse,  200...299 ~= response.statusCode {
                    
                    completion(true, json as AnyObject)
                    
                } else {
                    
                    completion(false, nil)
                }
            })
            
            }.resume()
    }
}
