//
//  ChartView.swift
//  GetDog
//
//  Created by Roman Rakhlin on 11/12/23.
//

import SwiftUI

struct ChartView: View {
    @State var pickerSelection = 0
    @Binding var stepsEveryDay: [Int]
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            ForEach(Array(stepsEveryDay.enumerated()), id: \.element) { index, element in
                BarView(
                    dayOfWeek: index,
                    maxValue: stepsEveryDay.max()!,
                    value: element
                )
            }
//            ForEach(stepsEveryDay, id: \.self) { element in
//                BarView(
//                    dayOfWeek: stepsEveryDay.firstIndex(of: element)!,
//                    maxValue: stepsEveryDay.max()!,
//                    value: element
//                )
//            }
        }
    }
}

struct BarView: View{

    var dayOfWeek: Int
    var maxValue: Int
    var value: Int
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                VStack {
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 4)
                        .frame(
                            width: 30,
                            height: abs(CGFloat(calculateHeight(maxHeight: proxy.size.height)))
                        )
                        .foregroundColor(.orange)
                }
                
                VStack {
                    switch dayOfWeek {
                    case 0:
                        Text("Mon")
                    case 1:
                        Text("Tue")
                    case 2:
                        Text("Wed")
                    case 3:
                        Text("Thu")
                    case 4:
                        Text("Fri")
                    case 5:
                        Text("Sat")
                    default:
                        Text("Sun")
                    }
                }
                .font(.system(size: 14, weight: .semibold))
                .fontDesign(.rounded)
                .foregroundColor(.black)
            }
        }
    }
    
    private func calculateHeight(maxHeight: CGFloat) -> CGFloat {
        let percentage = CGFloat(value) / CGFloat(maxValue)
        return min(maxHeight, maxHeight * percentage) - 40
    }
}
