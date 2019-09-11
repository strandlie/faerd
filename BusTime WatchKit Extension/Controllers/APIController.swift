//
//  APIController.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 21/06/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

class APIController: NSObject  {
    let GLOBAL_MAX_STOPS = 30
    let SEARCH_RADIUS = 1000.0
    
    let REST_API_ENDPOINT = "https://rp.atb.no/scripts/TravelMagic/TravelMagicWE.dll/mapjson"
    let SOAP_API_ENDPOINT = "http://st.atb.no:90/SMWS/SMService.svc"
    
    let API_REQUESTOR_REF = "ATB"
    
    enum CodingKeys: String, CodingKey {
        case longitude = "x"
        case latitude = "y"
        case identification = "v"
        case name = "n"
        case lines = "l"
        case serviceTypes = "st"
        case zone
    }
    
    static let shared = APIController()
    
    override init() {
        
    }
    
    func getNearbyStopsToAPIRequest(coordinate: CLLocation, limitStops: Int? = nil, radius: Double? = nil) -> [BusStop] {
        let eastLimit = locationWithBearing(bearing: 45, distanceMeters: radius ?? SEARCH_RADIUS, origin: coordinate.coordinate)
        let westLimit = locationWithBearing(bearing: 225, distanceMeters: radius ?? SEARCH_RADIUS, origin: coordinate.coordinate)
        
        let parameters: Parameters = [
            "x1": min(eastLimit.longitude, westLimit.longitude),
            "y1": min(eastLimit.latitude, westLimit.latitude),
            "x2": max(eastLimit.longitude, westLimit.longitude),
            "y2": max(eastLimit.latitude, westLimit.latitude)
        ]
        
        
        AF.request(REST_API_ENDPOINT, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let stopsArray = value as? Array<Dictionary<String, Any>> {
                    stopsArray.forEach { stop in

                        guard let name = stop[CodingKeys.name.rawValue] as? String,
                            let id = stop[CodingKeys.identification.rawValue] as? String,
                            let longitude = stop[CodingKeys.longitude.rawValue] as? Double,
                            let latitude = stop[CodingKeys.latitude.rawValue] as? Double,
                            let lines = stop[CodingKeys.lines.rawValue] as? Array<String> else {
                                fatalError("Unexpected format. Does not have all the expected fields.")
                        }
                        
                        
                        if BusStopList.shared.get(for: BusStop.getCorrectIdFrom(initial: id)) == nil {
                            // Only add a new busStop if none exists with the same ID
                            let busStop = BusStop(fromFullName: name, fromInitialId: id, longitude: longitude, latitude: latitude, lines: lines)
                            BusStopList.shared.stops.append(busStop)
                        }
                        
                    }
                    
                } else {
                    fatalError("Unexpected format. Got: \(value)")
                }
                    
                    
               
                
            case .failure(let value):
                print("Failure!")
                print("Value: \(value)")
                
            }
            
        }
        
        
        
        return []
        
    }
    
    
    
    func locationWithBearing(bearing:Double, distanceMeters:Double, origin:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let distRadians = distanceMeters / (6372797.6)
        
        let rbearing = bearing * Double.pi / 180.0
        
        let lat1 = origin.latitude * Double.pi / 180
        let lon1 = origin.longitude * Double.pi / 180
        
        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(rbearing))
        let lon2 = lon1 + atan2(sin(rbearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2 * 180 / Double.pi, longitude: lon2 * 180 / Double.pi)
    }
    
    
    //MARK: XML requests
    
    func getRealtimeDeparturesForAPIRequest(busStop: BusStop) {
        let date = Date()
        let calendar = Calendar.current
        
        let year = String(calendar.component(.year, from: date))
        var month = String(calendar.component(.month, from: date))
        var day = String(calendar.component(.day, from: date))
        var hour = String(calendar.component(.hour, from: date))
        var minute = String(calendar.component(.minute, from: date))
        var second = String(calendar.component(.second, from: date))
        
        
        
        func formatTime(unit: String) -> String {
            guard let unitInt = Int(unit) else {
                fatalError("Some wrong formatting somewhere. Value: \(unit)")
            }
            return unitInt < 10 ? "0\(unitInt)" : String(unitInt)
        }
        
        month = formatTime(unit: month)
        day = formatTime(unit: day)
        hour = formatTime(unit: hour)
        minute = formatTime(unit: minute)
        second = formatTime(unit: second)
        
        
        var xmlBody = ""
        xmlBody += "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:siri=\"http://www.siri.org.uk/siri\">"
           xmlBody += "<soapenv:Header/>"
            xmlBody += "<soapenv:Body>"
              xmlBody += "<siri:GetStopMonitoring>"
                 xmlBody += "<ServiceRequestInfo>"
                    xmlBody += "<siri:RequestTimestamp>\(year)-\(month)-\(day)T\(hour):\(minute):\(second)+02:00</siri:RequestTimestamp>"
                    xmlBody += "<siri:RequestorRef>\(API_REQUESTOR_REF)</siri:RequestorRef>"
                 xmlBody += "</ServiceRequestInfo>"
                 xmlBody += "<Request version=\"1.4\">"
                    xmlBody += "<siri:RequestTimestamp>\(year)-\(month)-\(day)T\(hour):\(minute):\(second)+02:00</siri:RequestTimestamp>"
                    xmlBody += "<siri:MonitoringRef>\(busStop.id)</siri:MonitoringRef>"
                 xmlBody += "</Request>"
              xmlBody += "</siri:GetStopMonitoring>"
           xmlBody += "</soapenv:Body>"
        xmlBody += "</soapenv:Envelope>"
        
        
        let headers: HTTPHeaders = [
            "Content-Type": "text/xml; charset=UTF-8",
            "SOAPAction": "GetStopMonitoring",
            "UserAgent": "BusTimeApp",
            "AcceptEncoding": "gzip,deflate",
            "Cache-Control": "no-cache",
            "Host": "st.atb.no:90",
            "Connection": "keep-alive"
        ]
        
        AF.request(SOAP_API_ENDPOINT, method: .post, encoding: xmlBody, headers: headers).responseString { response in
            print(response)
        }
    }
    
    
    
}

extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}
