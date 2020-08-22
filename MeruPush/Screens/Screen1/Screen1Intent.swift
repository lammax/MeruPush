//
//  Screen1Intent.swift
//  MeruPush
//
//  Created by Mac on 20.08.2020.
//  Copyright (c) 2020 Lammax. All rights reserved.
//
//  This file was generated by the MVI Xcode Templates so
//  you can apply MVI architecture to your iOS and Mac projects
//

import Combine
import SwiftUI

class Screen1Intent: ObservableObject {
    
    //private let data = DataManager.sharedInstance
    private var settings: CommonSettings!
    
    @Published var onAction: (() -> Void)?
    
    func setup(settings: CommonSettings) {
        self.settings = settings
        self.setupActions()
    }
    
    private func setupActions() {
        self.onAction = {
            print("Do your action here!")
        }
    }
    
}