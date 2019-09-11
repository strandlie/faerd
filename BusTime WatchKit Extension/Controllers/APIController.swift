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
    let SEARCH_RADIUS = 500.0
    
    let REST_API_ENDPOINT = "https://api.entur.io/geocoder/v1/reverse?"
    let SOAP_API_ENDPOINT = "http://st.atb.no:90/SMWS/SMService.svc"
    
    let API_REQUESTOR_REF = "strandlie_development - BussTid"
    
    static let shared = APIController()
    
    override init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case longitude = "point.lon"
        case latitude = "point.lat"
        case identification = "id"
        case name = "name"
        case properties = "properties"
        case geometry = "geometry"
        case stopsList = "features"
        case coordinates = "coordinates"
    }
    
    func updateNearbyStopsToAPIRequest(coordinate: CLLocation, limitStops: Int? = nil, radius: Double? = nil) {

        let parameters: Parameters = [
            "point.lat": coordinate.coordinate.latitude,
            "point.lon": coordinate.coordinate.longitude,
            "boundary.circle.radius": SEARCH_RADIUS / 1000,
            "size": limitStops ?? GLOBAL_MAX_STOPS,
            "layers": "venue"
        ]
        
        let headers: HTTPHeaders = [
            "ET-Client-Name": "strandlie_development - busstid"
        ]
        
        
        AF.request(REST_API_ENDPOINT, parameters: parameters, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                print(value)
                guard let body = value as? Dictionary<String, Any>, let stopsArray = body[CodingKeys.stopsList.rawValue] as? Array<Dictionary<String, Any>>  else {
                    fatalError("Unexpected format for body or stopsArray. Got: \(value)")
                }
                
                stopsArray.forEach { stop in
                    guard let properties = stop[CodingKeys.properties.rawValue] as? Dictionary<String, Any>,
                        let geometry = stop[CodingKeys.geometry.rawValue] as? Dictionary<String, Any>,
                        let coordinates = geometry[CodingKeys.coordinates.rawValue] as? Array<Double>,
                        let id = properties[CodingKeys.identification.rawValue] as? String,
                        let name = properties[CodingKeys.name.rawValue] as? String
                    else {
                        fatalError("Unexpected format for properties, geometry, coordinates, id or name. Got: \(stop)")
                    }
                    
                    let longitude = Float(coordinates[0])
                    let latitude = Float(coordinates[1])
                    
                    let busStop = BusStop(id: id, name: name, longitude: longitude, latitude: latitude)
                    BusStopList.shared.stops.append(busStop)
                    
                }
                
                    
                
            case .failure(let value):
                print("Failure!")
                print("Value: \(value)")
                
            }
            
        }
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
