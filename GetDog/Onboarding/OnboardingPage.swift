//
//  OnboardingPage.swift
//  Kids-App
//
//  Created by Roman Rakhlin on 11/11/23.
//

import Foundation
import SwiftUI

struct OnboardingPage: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let headline: String
    let image: String
    var isAccessPage: Bool = false
}
