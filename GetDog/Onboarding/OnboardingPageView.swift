//
//  OnboardingPageView.swift
//  GetDog
//
//  Created by Roman Rakhlin on 11/11/23.
//

import SwiftUI

struct OnboardingPageView: View {
    
    var page: OnboardingPage
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Spacer()
                
                Image(page.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    
                Spacer()
            }
            
            Text(page.title)
                .foregroundColor(.black)
                .font(.largeTitle)
                .fontWeight(.heavy)
                
            Text(page.headline)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            
            Spacer()
                
            OnboardingButtonView(pageModel: page, isStartButton: viewModel.isLastPage, viewModel: viewModel)
                .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
