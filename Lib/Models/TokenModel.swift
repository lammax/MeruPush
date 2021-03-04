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
        let tokenUUID: String = "50cbaa17-3fe5-4d1a-a18b-e4b43e788d01" //UUID().uuidString
        let deviceId: String = "e901ff3d1e7ff5e1e98f4d95e1cff5e1e98f4d95e1c"
        let pushToken: String
    }
    
}
