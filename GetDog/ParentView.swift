//
//  ParentView.swift
//  GetDog
//
//  Created by Roman Rakhlin on 11/11/23.
//

import SwiftUI

struct ParentView: View {
    
    private let healthKitManager = HealthKitManager.shared
    
    var body: some View {
        HomeView()
            .onAppear {
                guard !healthKitManager.isAuthorized else {
                    return
                }
                    
                healthKitManager.requestAccess { error in
                    if let error {
                        print(error)
                    }
                }
            }
    }
}

#Preview {
    ParentView()
}
