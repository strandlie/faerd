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
    
    init(stopID: String) {
        
        self.query = """
            {
                stopPlace(id: \"\(stopID)\") {
                    id
                    name
                    latitude
                    longitude
                    estimatedCalls(timeRange: 72100, numberOfDepartures: 10) {
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
    
