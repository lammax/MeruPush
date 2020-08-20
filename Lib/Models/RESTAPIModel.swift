//
//  RESTAPIModel.swift
//  MeruPush
//
//  Created by Mac on 20.08.2020.
//  Copyright © 2020 Lammax. All rights reserved.
//

import Foundation

enum REST {
    
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    enum API {

        
        enum Token: String {
            case putPushToken //http://178.213.145.180:8095/rest/putPushToken
            
            var path: String {
                "/rest/\(self.rawValue)"
            }
            
            var additionalHeaders: [String:String] {
                var headers: [String:String] = ["Content-Type" : "application/json; charset=utf-8"]
                
                let userPasswordString = "replicator:replicator"
                let userPasswordData = userPasswordString.data(using: .utf8)
                let base64EncodedCredential = userPasswordData!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
                let authString = "Basic \(base64EncodedCredential)"
                
                headers["Authorization"] = authString
                
                return headers
            }
            
            func getUrl(for serverAddress: String, additionalUrlPart: String = "") -> URL? {
                var urlString: String = serverAddress + self.path

                urlString += additionalUrlPart

                print(urlString)
                return URL(string: urlString)
            }
        }
        
    }
    
}
