//
//  NetService.swift
//  MeruPush
//
//  Created by Mac on 20.08.2020.
//  Copyright © 2020 Lammax. All rights reserved.
//

import Foundation

class NetService {

    static let sharedInstance = NetService()

    let session = URLSession(configuration: .default)

    typealias completionHandler = (Data?, URLResponse?, Error?) -> Void

    var tasks = [URLRequest: [completionHandler]]()

    func dataTask(for data: Data? = nil, with additionalHeaders: [String:String]? = nil, with url: URL, restMethod: REST.Method, completion: @escaping completionHandler) {
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        request.httpMethod = restMethod.rawValue
        
        if let headers = request.allHTTPHeaderFields, headers.count > 0, let adHeaders = additionalHeaders {
            
            for (key, value) in adHeaders {
                request.allHTTPHeaderFields?[key] = value
            }
            
        } else {
            request.allHTTPHeaderFields = additionalHeaders
        }
        
        
        // insert data to the request
        if let data = data {
            print(String(data: data, encoding: .utf8)! )
            request.httpBody = data
        }
        
        //session.configuration.httpAdditionalHeaders = additionalHeaders
        
        
        if tasks.keys.contains(request) {
            tasks[request]?.append(completion)
        } else {
            tasks[request] = [completion]
            
            let _ = self.session.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
                DispatchQueue.main.async {
                    
                    print("Finished network task")
                    if let d = data {
                        print(String(data: d, encoding: .utf8)!)
                    }
                    
                    if let e = error {
                        print(e)
                        print(e.localizedDescription)
                    }
                    
                    if let r = response {
                        print(r)
                        print(r.url)
                        print(r.debugDescription)
                        print(r.description)
                    }
                    

                    guard let completionHandlers = self?.tasks[request] else { return }
                    for handler in completionHandlers {
                        
                        print("Executing completion block")
                        
                        handler(data, response, error)
                    }
                    self?.tasks.removeValue(forKey: request)
                }
            }).resume()

        }
        
    }
}
