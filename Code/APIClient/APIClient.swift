//
//  Created by Pete Smith
//  http://www.petethedeveloper.com
//
//
//  License
//  Copyright © 2016-present Pete Smith
//  Released under an MIT license: http://opensource.org/licenses/MIT
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
    
    fileprivate static func clientURLRequest(_ url: String) -> URLRequest? {
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            return request
        }
        
        return nil
    }
    
    fileprivate static func dataTask(for request: URLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async(execute: {
                
                if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) , let response = response as? HTTPURLResponse,  200...299 ~= response.statusCode {
                    
                    completion(true, json as AnyObject)
                    
                } else {
                    
                    completion(false, nil)
                }
            })
            
        }.resume()
        
        session.finishTasksAndInvalidate()
    }
}
