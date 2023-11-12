//
//  HealthKitManager.swift
//  GetDog
//
//  Created by Roman Rakhlin on 11/11/23.
//

import HealthKit

enum HealthKitManagerError: Error {
    case healthDataNotAvailable
    case failedToFetchSteps
    case cannotAccessQuantityType
    case healthDataIsNotAuthorized
    case deniedAccess
    case readStepsCount
    case changeAuthorizationStatus
}

final class HealthKitManager: ObservableObject {
    
    @Published var isAuthorized = false
    private let healthStore = HKHealthStore()
    
    static let shared = HealthKitManager()
    
    init() {
        changeAuthorizationStatus { error in
            if let error {
                print(error)
            }
        }
    }
    
    public func requestAccess(completion: @escaping (Error?) -> Void) {
        requestHealthAccess { error in
            completion(error)
        }
    }
    
    public func readStepsTaken(
        from startDate: Date,
        to endDate: Date,
        completion: @escaping (Error?, Int?) -> ()
    ) {
        guard isAuthorized else {
            return completion(HealthKitManagerError.healthDataIsNotAuthorized, nil)
        }
        
        readStepsCount(from: startDate, to: endDate) { error, stepsCount in
            completion(error, stepsCount)
        }
    }
    
    public func getGender() -> Int {
        guard let biologicalSex = try? healthStore.biologicalSex() else {
            return 1
        }
        
        switch biologicalSex.biologicalSex {
        case .notSet:
            return 1
        case .female:
            return 0
        case .male:
            return 1
        case .other:
            return 1
        @unknown default:
            return 1
        }
    }
     
    public func getAge() -> Int {
        guard let dateOfBirthComponents = try? healthStore.dateOfBirthComponents() else {
            return 21
        }
        
        if let year = dateOfBirthComponents.year {
            return Calendar.current.component(.year, from: Date()) - year
        }
        
        return 21
    }
}

// MARK: - Helper Methods

extension HealthKitManager {
    private func changeAuthorizationStatus(completion: (Error?) -> Void) {
        getStepsQuantityType { error, stepsQuantityType in
            guard let stepsQuantityType else {
                return completion(HealthKitManagerError.changeAuthorizationStatus)
            }
            
            let status = healthStore.authorizationStatus(for: stepsQuantityType)
            
            switch status {
            case .notDetermined:
                isAuthorized = false
            case .sharingDenied:
                isAuthorized = false
            case .sharingAuthorized:
                isAuthorized = true
            @unknown default:
                isAuthorized = false
            }
            
            completion(nil)
        }
    }
    
    private func requestHealthAccess(completion: @escaping (Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            return completion(HealthKitManagerError.healthDataNotAvailable)
        }
        
        guard let stepCount = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            return completion(HealthKitManagerError.failedToFetchSteps)
        }
        
        var allTypes = Set([
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
            HKCharacteristicType(.biologicalSex),
            HKCharacteristicType(.dateOfBirth),
            HKQuantityType(.height),
            HKQuantityType(.bodyMass),
        ])
        allTypes.insert(stepCount)
        
        healthStore.requestAuthorization(toShare: [stepCount], read: allTypes) { allowed, error in
            if let error {
                return completion(error)
            }
            
            if !allowed {
                completion(HealthKitManagerError.deniedAccess)
            }
            
            completion(nil)
        }
    }
    
    private func readStepsCount(
        from startDate: Date,
        to endDate: Date,
        completion: @escaping (Error?, Int?) -> Void
    ) {
        getStepsQuantityType { error, stepsQuantityType in
            if let error {
                return completion(error, nil)
            }
            
            guard let stepsQuantityType else {
                return completion(HealthKitManagerError.readStepsCount, nil)
            }
            
            let startOfDay = Calendar.current.startOfDay(for: startDate)
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endDate, options: .strictStartDate)
            let query = HKStatisticsQuery(
                quantityType: stepsQuantityType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, error in
                guard let result, let stepsCount = result.sumQuantity() else {
                    return completion(nil, 0)
                }
                
                completion(nil, Int(stepsCount.doubleValue(for: HKUnit.count())))
            }
            
            healthStore.execute(query)
        }
    }
    
    private func getStepsQuantityType(completion: (Error?, HKQuantityType?) -> Void) {
        guard let stepQuantityType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            completion(HealthKitManagerError.cannotAccessQuantityType, nil)
            return
        }
        
        completion(nil, stepQuantityType)
    }
}
