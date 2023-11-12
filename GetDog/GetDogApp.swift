//
//  GetDogApp.swift
//  GetDog
//
//  Created by Roman Rakhlin on 11/11/23.
//

import SwiftUI

@main
struct Kids_AppApp: App {
    
    @AppStorage("isOnboardingCompleted") var isOnboardingCompleted: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if !isOnboardingCompleted {
                OnboardingView()
            } else {
                ParentView()
            }
        }
    }
}
