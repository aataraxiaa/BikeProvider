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
    static func get(from url: String,
                                 withCompletion completion: @escaping (Result<Data>) -> Void) -> URLSessionDataTask? {
        
        guard let request = clientURLRequest(url) else { return nil }
        
        return dataTask(for: request, withCompletion: completion)
    }
    
    fileprivate static func clientURLRequest(_ url: String) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        
        let request = URLRequest(url: url)
        return request
    }
    
    fileprivate static func dataTask(for request: URLRequest,
                                                  withCompletion completion: @escaping (Result<Data>) -> Void) -> URLSessionDataTask {
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let data = data,
                    let response = response as? HTTPURLResponse,
                    200...299 ~= response.statusCode {
                    
                    completion(.success(data))
                }
            })
        }
        
        dataTask.resume()
        
        session.finishTasksAndInvalidate()
        
        return dataTask
    }
}
