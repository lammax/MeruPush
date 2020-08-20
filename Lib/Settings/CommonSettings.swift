//
//  CommonSettings.swift
//  MeruPush
//
//  Created by Mac on 20.08.2020.
//  Copyright © 2020 Lammax. All rights reserved.
//

import Combine
import UIKit

enum CurrentScreen  {
    case start
    case screen1
    case screen2
}

class CommonSettings: ObservableObject {
    
    public static let sharedInstance = CommonSettings()
    
    //MARK: Screens navigation
    @Published var currentScreen: CurrentScreen = .start
    @Published var pushToken: String = ""
    @Published var deviceToken: String = ""
    @Published var deviceID: String = ""
    
    init() {
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            print(uuid)
            deviceID = uuid
        }
    }

    private var previousScreens: [CurrentScreen] = []
    func pushScreen(_ screen: CurrentScreen) {
        previousScreens.append(self.currentScreen)
        self.currentScreen = screen
    }
    func popScreen() {
        self.currentScreen = previousScreens.popLast() ?? .start
    }
    func clearNavigationStack() {
        self.previousScreens.removeAll()
    }

}
