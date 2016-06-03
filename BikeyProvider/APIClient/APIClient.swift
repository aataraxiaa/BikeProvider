//
//  APIClient.swift
//  Bikey
//
//  Created by Peter Smith on 01/02/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//

import Foundation

struct APIClientConstants {
    static let baseURL = "http://api.citybik.es/v2/networks/"
    static let requestOptions = "?fields=stations"
}

struct APIClient {
    
    static func get(url: String, completion: (success: Bool, object: AnyObject?) -> ()) {
        
        if let request = clientURLRequest(url) {
            dataTask(request, completion: completion)
        }
    }
    
    private static func clientURLRequest(url: String) -> NSMutableURLRequest? {
        if let url = NSURL(string: url) {
            let request = NSMutableURLRequest(URL: url)
            return request
        }
        return nil
    }
    
    private static func dataTask(request: NSMutableURLRequest, completion: (success: Bool, object: AnyObject?) -> ()) {
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let data = data, json = try? NSJSONSerialization.JSONObjectWithData(data, options: []), response = response as? NSHTTPURLResponse where 200...299 ~= response.statusCode {
                    completion(success: true, object: json)
                } else {
                    completion(success: false, object: nil)
                }
            })
            
            }.resume()
    }
}
