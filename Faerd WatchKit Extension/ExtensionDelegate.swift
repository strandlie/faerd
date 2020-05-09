//
//  ExtensionDelegate.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 20/06/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import WatchKit
import StoreKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    func applicationDidFinishLaunching() {
        SKPaymentQueue.default().add(StoreObserver.shared)
        StoreController.shared.fetchProductInformation()
    }

    func applicationDidBecomeActive() {
        if let currentLocation = User.shared.currentLocation {
                  LocationController.shared.updateNearbyStopsTo(coordinate: currentLocation)
                      
        } else {
            let delay = DispatchTime.now() + .milliseconds(1000)
            DispatchQueue.main.asyncAfter(deadline: delay) {
                LocationController.shared.updateStopsNearUser()
            }
        }
        BusStopList.shared.updateDepartures()
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
    func applicationDidEnterBackground() {
        BusStopList.shared.clean()
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date.init(timeInterval: 1200, since: Date()), userInfo: nil, scheduledCompletion: backgroundRefreshRunning)
    }
    
    private func backgroundRefreshRunning(error: Error?) {
        if (error != nil) {
            print("Error running background task: \(error.debugDescription)")
        }
    }
    
    

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        print("Background task")
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                
                LocationController.shared.updateStopsNearUser()
                print("Updated stops and departures in the background")
                backgroundTask.setTaskCompletedWithSnapshot(true)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: false, estimatedSnapshotExpiration: Date.init(timeInterval: 1200, since: Date()), userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }

}
