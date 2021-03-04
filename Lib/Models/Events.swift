//
//  Events.swift
//  MeruPush
//
//  Created by Mac on 22.08.2020.
//  Copyright © 2020 Lammax. All rights reserved.
//

import Foundation

public enum Events: String {
    case event1 = "2101"
    case event2 = "2201"
    case unknown
    
    init(eventID: String) {
        switch eventID {
        case "2101": self = .event1
        case "2201": self = .event2
        default: self = .unknown
        }
    }
    
    var screen: CurrentScreen {
        switch self {
        case .event1: return .screen1
        case .event2: return .screen2
        case .unknown: return .start
        }
    }
}
