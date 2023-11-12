//
//  HomeView.swift
//  GetDogWatch Watch App
//
//  Created by Roman Rakhlin on 11/12/23.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @State private var stepsCountThisWeek: Int = 0
    @State private var weekProgress: Double = 0
    @State private var level: Int = 1
    @State private var scale: CGFloat = 1
    @State private var stepsArray: [Int] = []
    @State private var predictedStepsLeft: Int = 0
    
    var body: some View {
        VStack {
            Image("level_0_head")
                .resizable()
                .frame(width: 140, height: 140)
                .scaledToFit()
                .scaleEffect(x: 1, y: scale, anchor: .bottom)
            
            VStack {
                HStack {
                    Text("Lvl. \(level - 1)")
                        .font(.system(size: 12, weight: .semibold))
                        .fontDesign(.rounded)
                    
                    Spacer()
                    
                    Text("\(stepsCountThisWeek) steps")
                        .font(.system(size: 8, weight: .medium))
                        .fontDesign(.rounded)
                    
                    Spacer()
                    
                    Text("Lvl. \(level)")
                        .font(.system(size: 12, weight: .semibold))
                        .fontDesign(.rounded)
                }
                
                ProgressBarView(value: $weekProgress)
                    .frame(height: 14)
            }
        }
        .padding(.horizontal, 10)
        .onAppear {
            if !viewModel.healthIsAuthorized {
                viewModel.askHealthAccess {
                    viewModel.getStepsTakenThisWeek { stepsCount in
                        stepsCountThisWeek = stepsCount
                        weekProgress = stepsCount == 0 ? Double(stepsCount) : min(1.0, Double(stepsCount) / Double(stepsCount + predictedStepsLeft))
                    }
                    
                    viewModel.getArrayOfStepsForThisWeek { array in
                        stepsArray = array
                    }
                    
                    withAnimation(.smooth(duration: 0.6).repeatForever()) {
                        scale = 1.02
                    }
                }
            } else {
                viewModel.getStepsTakenThisWeek { stepsCount in
                    stepsCountThisWeek = stepsCount
                    weekProgress = stepsCount == 0 ? Double(stepsCount) : min(1.0, Double(stepsCount) / Double(stepsCount + predictedStepsLeft))
                }
                
                viewModel.getArrayOfStepsForThisWeek { array in
                    stepsArray = array
                }
                
                withAnimation(.smooth(duration: 0.6).repeatForever()) {
                    scale = 1.02
                }
            }
        }
    }
}
