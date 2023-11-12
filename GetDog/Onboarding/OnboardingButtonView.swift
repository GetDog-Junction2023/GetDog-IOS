//
//  OnboardingButtonView.swift
//  Kids-App
//
//  Created by Roman Rakhlin on 11/11/23.
//

import SwiftUI

struct OnboardingButtonView: View {
    
    var pageModel: OnboardingPage
    var isStartButton: Bool = false
    @ObservedObject var viewModel: OnboardingViewModel
    @AppStorage("isOnboardingCompleted") var isOnboardingCompleted: Bool?
    @AppStorage("firstLaunchDate") var firstLaunchDate: Date?
    
    var body: some View {
        Button(action: {
            if isStartButton {
                isOnboardingCompleted = true
                firstLaunchDate = Date()
            } else {
                if pageModel.isAccessPage {
                    viewModel.askHealthAccess {
                        withAnimation {
                            viewModel.goToNextPage()
                        }
                    }
                } else {
                    withAnimation {
                        viewModel.goToNextPage()
                    }
                }
            }
        }) {
            HStack(spacing: 8) {
                Spacer()
                
                Text(isStartButton ? "Let's go" : "Continue")
                
                Spacer()
            }
            .padding()
            .background(.blue)
            .cornerRadius(12)
        }
        .accentColor(Color.white)
    }
}

//#Preview {
//    OnboardingButtonView()
//}
