//
//  HealthKitHelper.swift
//  myResearchKit
//
//  Created by Shashank Kothapalli on 8/5/15.
//  Copyright (c) 2015 Amgen. All rights reserved.
//

import Foundation
import HealthKit
import Charts

var dates = [String]()
var stepsOver = [Double]()
var heartRate = [Double]()
var dateOfMax = [String]()

class HealthKit
{
    
    let HealthKitStore:HKHealthStore = HKHealthStore()
    
    func authorizeHealthKit(completion: ((success: Bool, error:NSError!)->Void)!){
        
        //types of info to write
        let infoToRead:Set = [
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
        ]
        let infoToWrite:Set = [
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,
        ]
        //check if store is not available
        if !HKHealthStore.isHealthDataAvailable(){
            let error = NSError(domain: "Amgen HealthKit",
                code: 1111,
                userInfo: [NSLocalizedDescriptionKey: "HK Store Not Available"]
            )
            if(completion != nil){
                completion(success:false, error: error)
            }
            return
        }
        
        HealthKitStore.requestAuthorizationToShareTypes(infoToWrite, readTypes:infoToRead){(success,error) -> Void in
            if(completion != nil){
                completion(success:success, error: error)
            }
        }
    }
    
    func readSteps() -> Void
    {
        print("Entered read profile")
        let calendar = NSCalendar.currentCalendar()
        
        let interval = NSDateComponents()
        interval.day = 7
        
        // Set the anchor date to Monday at 3:00 a.m.
        let anchorComponents =
        calendar.components([.Day, .Month, .Year, .Weekday], fromDate: NSDate())
        
        let offset = (7 + anchorComponents.weekday - 2) % 7
        anchorComponents.day -= offset
        anchorComponents.hour = 3
        
        let anchorDate = calendar.dateFromComponents(anchorComponents)
        
        let quantityType =
        HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        // Create the query
        let query = HKStatisticsCollectionQuery(quantityType: quantityType!,
            quantitySamplePredicate: nil,
            options: .CumulativeSum,
            anchorDate: anchorDate!,
            intervalComponents: interval)
        
        // Set the results handler
        query.initialResultsHandler = {
            query, results, error in
            
            if error != nil {
                // Perform proper error handling here
                print("*** An error occurred while calculating the statistics: \(error!.localizedDescription) ***")
                abort()
            }
            
            let endDate = NSDate()
            let startDate =
            calendar.dateByAddingUnit(.NSMonthCalendarUnit,
                value: -3, toDate: endDate, options: [])
            
            // Plot the weekly step counts over the past 3 months
            results!.enumerateStatisticsFromDate(startDate!, toDate: endDate) {
                statistics, stop in
                
                if let quantity = statistics.sumQuantity() {
                    let date = statistics.startDate
                    let stepsValue = quantity.doubleValueForUnit(HKUnit.countUnit())
                    
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MMM"
                    
                    var month = dateFormatter.stringFromDate(date)
                    dates.append(month)
                    stepsOver.append(stepsValue)
                    
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.HealthKitStore.executeQuery(query)
        })
    }
    
    func readHeartRate() -> Void
    {
        print("inside heart rate")
        let heartRateValue = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        let calendar = NSCalendar.currentCalendar()
        
        let endDate = calendar.dateByAddingUnit(.WeekOfYear, value: 0, toDate: NSDate(), options:[])
        let startDate = calendar.dateByAddingUnit(.WeekOfYear, value: -2, toDate: NSDate(), options: [])
        
        let samplePredicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: HKQueryOptions.StrictStartDate)
        
        let sorter = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)

        let query = HKSampleQuery(sampleType:heartRateValue!, predicate:samplePredicate, limit:600, sortDescriptors:[sorter], resultsHandler:{(query, results, error) in
        
            for sample in results! {
                let heartRateUnit: HKUnit = HKUnit.countUnit().unitDividedByUnit(HKUnit.minuteUnit())
                let quantity = (sample as! HKQuantitySample).quantity
                
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MMM dd"
                
                var day = dateFormatter.stringFromDate(sample.startDate)
                dateOfMax.append(day)
                heartRate.append(quantity.doubleValueForUnit(heartRateUnit))
            }
            
            var error: NSError? = nil
        })
        dispatch_async(dispatch_get_main_queue(), {
            self.HealthKitStore.executeQuery(query)
        })
    }
    
}
