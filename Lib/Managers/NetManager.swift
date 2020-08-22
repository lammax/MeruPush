//
//  NetManager.swift
//  MeruPush
//
//  Created by Mac on 23.08.2020.
//  Copyright © 2020 Lammax. All rights reserved.
//

import Foundation

class NetManager {
    
    class func putPushToken(token: String) {
        let net = NetService.sharedInstance
        let encoder = JSONEncoder()
        
        let api = REST.API.Token.putPushToken
        let url = api.getUrl(for: Servers.addresses.first!)!
        let regModel = Token.PutPush(pushToken: token)
        let data = try? encoder.encode(regModel)
        
        net.dataTask(for: data, with: api.additionalHeaders , with: url, restMethod: .POST) { (data, response, error) in
            print(data)
            print(response)
            print(error)
        }
    }
    
    
}
