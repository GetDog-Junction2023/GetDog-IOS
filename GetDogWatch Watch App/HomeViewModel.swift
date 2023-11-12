//
//  HomeViewModel.swift
//  GetDog
//
//  Created by Roman Rakhlin on 11/11/23.
//

import SwiftUI
import HealthKit
import CoreML

final class HomeViewModel: ObservableObject {
    
    var stepsArray: [Int] = []
    
    private let healthKitManager = HealthKitManager.shared
    
    var healthIsAuthorized: Bool {
        healthKitManager.isAuthorized
    }
    
    func calculateLevel(from persentage: Double) -> Int {
        let clampedValue = max(0.0, min(1.0, persentage))
        let level = Int(clampedValue * 5) + 1
        return level
    }
    
    func askHealthAccess(completion: @escaping () -> Void) {
        healthKitManager.requestAccess { error in
            if let error = error as? HealthKitManagerError {
                if error == .deniedAccess {
                    print("User denied access to Health")
                }
                
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func getStepsTakenThisWeek(completion: @escaping (Int) -> Void) {
        guard  let startOfTheWeek = Date().startOfWeek else {
            return
        }
        
        healthKitManager.getStepsTaken(from: startOfTheWeek, to: Date()) { error, stepsCount in
            if let error {
                print(error)
                return
            }
            
            guard let stepsCount else {
                return
            }
            
            completion(stepsCount)
        }
    }
    
    func getArrayOfStepsForThisWeek(completion: @escaping ([Int]) -> Void) {
        guard let startOfTheWeek = Date().startOfWeek else {
            return completion([0, 0, 0, 0, 0, 0, 0])
        }

        var stepsArray: [Int] = []
        var dateArray: [Date] = []

        for i in 0..<7 {
            if let nextDate = Calendar.current.date(byAdding: .day, value: i, to: startOfTheWeek) {
                dateArray.append(nextDate)
            }
        }
        
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "my_queue")
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        
        dispatchQueue.async { [self] in
            for currentDate in dateArray {
                let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
                
                dispatchGroup.enter()
                
                healthKitManager.getStepsTaken(from: currentDate, to: nextDay) { error, stepsCount in
                    if let _ = error {
                        return completion([0, 0, 0, 0, 0, 0, 0])
                    }
                    
                    guard let stepsCount else {
                        return completion([0, 0, 0, 0, 0, 0, 0])
                    }
                
                    stepsArray.append(stepsCount)
                    
                    dispatchSemaphore.signal()
                    dispatchGroup.leave()
                }
                
                dispatchSemaphore.wait()
            }
        }
        
        dispatchGroup.notify(queue: dispatchQueue) {
            if stepsArray.count < 7 {
                for _ in stepsArray.count..<7 {
                    stepsArray.append(0)
                }
            }
            
            self.stepsArray = stepsArray
            completion(stepsArray)
        }
    }
}
