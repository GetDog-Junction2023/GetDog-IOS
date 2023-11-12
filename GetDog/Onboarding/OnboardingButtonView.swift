//
//  OnboardingButtonView.swift
//  Kids-App
//
//  Created by Roman Rakhlin on 11/11/23.
//

import SwiftUI

struct OnboardingButtonView: View {
    
    var isStartButton: Bool = false
    @ObservedObject var viewModel: OnboardingViewModel
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    var body: some View {
        Button(action: {
            if isStartButton {
                isOnboarding = false
            } else {
                withAnimation {
                    viewModel.goToNextPage()
                }
            }
        }) {
            HStack(spacing: 8) {
                Text(isStartButton ? "Let's go" : "Continue")
                
                Image(systemName: "arrow.right.circle")
                    .imageScale(.large)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule().strokeBorder(Color.white, lineWidth: 1.25)
            )
        }
        .accentColor(Color.white)
    }
}

//#Preview {
//    OnboardingButtonView()
//}
