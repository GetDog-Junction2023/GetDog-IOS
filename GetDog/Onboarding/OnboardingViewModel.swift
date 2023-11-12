//
//  OnboardingViewModel.swift
//  GetDog
//
//  Created by Roman Rakhlin on 11/11/23.
//

import SwiftUI

final class OnboardingViewModel: ObservableObject {
    
    private let healthKitManager = HealthKitManager.shared
    
    @Published var selectedPage: Int = 0
    
    public var isLastPage: Bool {
        selectedPage == onboardingPages.count - 1
    }
    
    private(set) var onboardingPages: [OnboardingPage] = [
        OnboardingPage(title: "Track Your Activity", headline: "Show your parents that you are responsible enough for owning a dog.", image: "Activity"),
        OnboardingPage(title: "Accesses", headline: "Allow Access to your Health Data", image: "HealthKit", isAccessPage: true),
        OnboardingPage(title: "Apple Watch App + Widgets", headline: "This app also contains Apple Watch app and widgets", image: "AppleWatch"),
    ]
    
    func askHealthAccess(completion: @escaping () -> Void) {
        healthKitManager.requestAccess { error in
            if let error = error as? HealthKitManagerError {
                if error == .deniedAccess {
                    print("User denied access to Health")
                }
                
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func goToNextPage()  {
        selectedPage += 1
    }
}
