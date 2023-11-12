//
//  HomeView.swift
//  GetDog
//
//  Created by Roman Rakhlin on 11/11/23.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @State private var stepsCountThisWeek: Int = 0
    @State private var weekProgress: Double = 0
    @State private var level: Int = 0
    @State private var scale: CGFloat = 1
    @State private var stepsArray: [Int] = []
    @State private var predictedStepsLeft: Int = 0
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    if level > 1 {
                        Image("level\(level - 1)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .grayscale(0.99)
                    } else {
                        Color.clear.frame(width: 80)
                    }
                    
                    Image("level\(level)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 300)
                        .scaleEffect(x: 1, y: scale, anchor: .bottom)
                    
                    Spacer()
                    
                    if level < 5 {
                        Image("level\(level + 1)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .grayscale(0.99)
                    } else {
                        Color.clear.frame(width: 80)
                    }
                }
                
                VStack {
                    HStack {
                        Text("Lvl. \(level - 1)")
                            .font(.system(size: 22, weight: .semibold))
                            .fontDesign(.rounded)
                        
                        Spacer()
                        
                        Text("\(stepsCountThisWeek) steps")
                            .font(.system(size: 18, weight: .medium))
                            .fontDesign(.rounded)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Text("Lvl. \(level)")
                            .font(.system(size: 22, weight: .semibold))
                            .fontDesign(.rounded)
                    }
                    .padding(.horizontal, 10)
                    
                    ProgressBarView(value: $weekProgress)
                        .frame(height: 32)
                }
                .padding(.top, 10)
                
                Spacer()
                
                VStack {
                    Text("You need to reach \(predictedStepsLeft) steps till the end of the week.")
                        .font(.system(size: 18, weight: .thin))
                        .fontDesign(.rounded)
                        .multilineTextAlignment(.center)
                        .lineLimit(2, reservesSpace: true)
                    
                    ChartView(stepsEveryDay: $stepsArray)
                        .frame(height: 240)
                }
                .padding(.top, 40)
                .padding(.bottom, 20)
            }
            .padding(.top, 80)
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Home")
                            .fontDesign(.rounded)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                        
                        if let subtitle = viewModel.createPageSubtitle() {
                            Text(subtitle)
                                .fontDesign(.rounded)
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.orange)
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 32)
        .onAppear {
            predictedStepsLeft = viewModel.predictSteps() ?? 0
            
            viewModel.getStepsTakenThisWeek { stepsCount in
                stepsCountThisWeek = stepsCount
                weekProgress = min(1.0, Double(stepsCount) / Double(stepsCount + predictedStepsLeft))
                level = viewModel.calculateLevel(from: weekProgress)
            }
            
            viewModel.getArrayOfStepsForThisWeek { array in
                stepsArray = array
            }
            
            withAnimation(.smooth(duration: 0.4).repeatForever()) {
                scale = 1.04
            }
        }
    }
}
