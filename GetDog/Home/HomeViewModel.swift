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
    
    @AppStorage("firstLaunchDate") var firstLaunchDate: Date = Date()
    private let healthKitManager = HealthKitManager.shared
    
    func calculateLevel(from persentage: Double) -> Int {
        let clampedValue = max(0.0, min(1.0, persentage))
        let level = Int(clampedValue * 5) + 1
        return level
    }
    
    func createPageSubtitle() -> String? {
        let currentDate = Date()
        
        if
            let startOfWeek = currentDate.startOfWeek,
            let endOfWeek = currentDate.endOfWeek
        {
            let startWeekDay = startOfWeek.formatted(Date.FormatStyle().day(.twoDigits))
            let startMonthName = startOfWeek.formatted(Date.FormatStyle().month(.abbreviated))
            
            let endWeekDay = endOfWeek.formatted(Date.FormatStyle().day(.twoDigits))
            let endMonthName = endOfWeek.formatted(Date.FormatStyle().month(.abbreviated))
            
            return "\(startWeekDay) \(startMonthName) - \(endWeekDay) \(endMonthName)"
        } else {
            return nil
        }
    }
    
    func getStepsTakenThisWeek(completion: @escaping (Int) -> Void) {
        guard let startOfTheWeek = Date().startOfWeek else {
            return
        }
        
        healthKitManager.readStepsTaken(from: startOfTheWeek, to: Date()) { error, stepsCount in
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
        let dispatchQueue = DispatchQueue(label: "any-label-name")
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        
        dispatchQueue.async { [self] in
            for currentDate in dateArray {
                let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!

                dispatchGroup.enter()
                
                healthKitManager.readStepsTaken(from: currentDate, to: nextDay) { error, stepsCount in
                    if let error = error {
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
    
    func predictSteps() -> Int? {
        let age = healthKitManager.getAge()
        let gender = healthKitManager.getGender()
        let height: Double = 180
        let weight: Double = 80
        let degrees: Double = 10
        
        guard
            let model = try? StepsPrediction(),
            let prediction = try? model.prediction(
                dayOfWeek: Double(Calendar.current.component(.weekday, from: Date())) - 1,
                degrees: degrees,
                lastWeekAverageSteps: Double(stepsArray.reduce(0, +)) / Double(stepsArray.count),
                gender: Double(gender),
                age: Double(age),
                weight: weight,
                height: height
            )
        else { return 0 }
        
        return Int(prediction.steps)
    }
}
