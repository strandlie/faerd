//
//  FerdComplicationDataSource.swift
//  Ferd WatchKit Extension
//
//  Created by Håkon Strandlie on 08/02/2020.
//  Copyright © 2020 Håkon Strandlie. All rights reserved.
//

import WatchKit

class FerdComplicationDataSource: NSObject, CLKComplicationDataSource {
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        /*var template: CLKComplicationTemplate? = nil
        switch(complication.family) {
        case .modularSmall:
            let modularSmallTemplate = CLKComplicationTemplateModularSm
        }*/
    }
    

}
