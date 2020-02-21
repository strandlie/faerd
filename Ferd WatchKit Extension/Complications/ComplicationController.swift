//
//  FerdComplicationDataSource.swift
//  Ferd WatchKit Extension
//
//  Created by Håkon Strandlie on 08/02/2020.
//  Copyright © 2020 Håkon Strandlie. All rights reserved.
//
import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        guard let image = UIImage(named: "LogoOnly") else {
            fatalError("Could not find the LogoOnly image")
        }
        switch(complication.family) {
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallSimpleImage()
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .modularLarge:
            let template = CLKComplicationTemplateModularSmallSimpleImage()
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .utilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallSquare()
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .extraLarge:
            let template = CLKComplicationTemplateExtraLargeSimpleImage()
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        case .graphicCircular:
            let template = CLKComplicationTemplateGraphicCircularImage()
            template.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        default:
            handler(nil)
        }
    }

    

}
