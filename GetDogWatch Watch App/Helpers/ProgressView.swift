//
//  ProgressView.swift
//  GetDog
//
//  Created by Roman Rakhlin on 11/11/23.
//

import SwiftUI

struct ProgressBarView: View {
    
    @Binding var value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(
                    width: geometry.size.width ,
                    height: geometry.size.height
                )
                .opacity(0.3)
                .foregroundColor(.orange.opacity(0.8))
                    
                Rectangle().frame(
                    width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width),
                    height: geometry.size.height
                )
                .foregroundColor(.orange)
            }
            .cornerRadius(45.0)
        }
    }
}
