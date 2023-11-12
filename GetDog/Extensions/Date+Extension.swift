//
//  Data+Extension.swift
//  GetDog
//
//  Created by Roman Rakhlin on 11/11/23.
//

import Foundation

extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else {
            return nil
        }
        
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
}
