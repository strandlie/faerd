//
//  GraphQLQuery.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 21/09/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation

struct GraphQLQuery: Codable {
    
    let query: String
    
    // First argument is number of hours
    let TIME_RANGE = String(12 * (60 * 60))
    
    let NUM_DEPARTURES = String(100)
    
    init(stopID: String) {
        
        self.query = """
            {
                stopPlace(id: \"\(stopID)\") {
                    id
                    name
                    latitude
                    longitude
                    estimatedCalls(timeRange: \(TIME_RANGE), numberOfDepartures: 100) {
                        serviceJourney {
                            journeyPattern {
                                line {
                                    id
                                    publicCode
                            }
                        }
                    }
                    destinationDisplay {
                        frontText
                    }
                    realtime
                    expectedArrivalTime
                }
            }
        }
        """
    }

}
    
