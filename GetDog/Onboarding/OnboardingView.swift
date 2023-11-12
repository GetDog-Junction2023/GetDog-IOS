//
//  OnboardingView.swift
//  Kids-App
//
//  Created by Roman Rakhlin on 11/11/23.
//

import SwiftUI

struct OnboardingView: View {
    
    @StateObject var viewModel = OnboardingViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.selectedPage) {
            ForEach(Array(viewModel.onboardingPages.enumerated()), id: \.element) { index, page in
                OnboardingPageView(page: page, viewModel: viewModel).tag(index)
                    .padding(.top, 100)
                    .padding(.bottom, 100)
            }
        }
        .ignoresSafeArea()
        .tabViewStyle(PageTabViewStyle())
        .padding(.bottom, 20)
    }
    
    func goToNextPage() {
        viewModel.selectedPage += 1
    }
}
