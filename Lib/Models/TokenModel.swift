//
//  TokenModel.swift
//  MeruPush
//
//  Created by Mac on 20.08.2020.
//  Copyright © 2020 Lammax. All rights reserved.
//

import Foundation

enum Token {
    
    struct PutPush: Encodable {
        let tokenUUID: String
        let deviceId: String
        let pushToken: String
    }
    
}
