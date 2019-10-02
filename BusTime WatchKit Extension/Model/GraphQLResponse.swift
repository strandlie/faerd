//
//  GraphQLQuery.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 21/09/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation

struct GraphQLResponse: Codable {
    
    struct Data: Codable {
        struct StopPlace: Codable {
               let id: String
               let name: String
               
               struct EstimatedCall: Codable {
                   struct ServiceJourney: Codable {
                       struct JourneyPattern: Codable {
                           struct Line: Codable {
                               let id: String
                               let publicCode: String
                           }
                           let line: Line
                       }
                       let journeyPattern: JourneyPattern
                   }
                   
                   struct DestinationDisplay: Codable {
                       let frontText: String
                   }
                   
                   
                   let serviceJourney: ServiceJourney
                   let destinationDisplay: DestinationDisplay
                   let realtime: Bool
                   let expectedArrivalTime: String
               }
               
               var estimatedCalls: [EstimatedCall]
               
           }
           let stopPlace: StopPlace
    }
    
    let data: Data
}
