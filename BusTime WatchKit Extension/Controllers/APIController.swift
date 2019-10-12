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
    let GRAPHQL_API_ENDPOINT = "https://api.entur.io/journey-planner/v2/graphql"
    
    let API_REQUESTOR_REF = "strandlie_development - BussTid"
    
    let DATE_TIME_FORMAT = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    
    static let shared = APIController()
    
    override init() {
        print("APIController initialized!")
        
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
            "ET-Client-Name": API_REQUESTOR_REF
        ]
        
        AF.request(REST_API_ENDPOINT, parameters: parameters, headers: headers).responseDecodable { (response: DataResponse<NearbyStopsResponse, AFError>) in
            switch response.result {
            case .success(let nearbyStops):
                var stops = [BusStop]()
                
                nearbyStops.features.forEach { stop in
                    let busStop = BusStop(id: stop.properties.id, name: stop.properties.name, longitude: stop.geometry.longitude, latitude: stop.geometry.latitude)
                    
                    stops.append(busStop)
                }
                
                BusStopList.shared.stops = stops
                
            case .failure(let value):
                print("Failure!")
                print("Value: \(value)")
                
            }
            
        }
        
    }
    
    
    //MARK: GraphQL requests
    
    func getRealtimeDeparturesForAPIRequest(busStop: BusStop) {

        let graphQLQuery = GraphQLQuery(stopID: busStop.id)
        guard let queryString = try? JSONEncoder().encode(graphQLQuery) else {
            fatalError("graphQLQuery does not have the expected format.")
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "ET-Client-Name": API_REQUESTOR_REF
        ]
        
        guard let url = URL(string: GRAPHQL_API_ENDPOINT) else {
            fatalError("GRAPHQL_API_ENDPOINT is not valid string. Got: \(GRAPHQL_API_ENDPOINT)")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = queryString
        urlRequest.method = .post
        urlRequest.headers = headers
        
        AF.request(urlRequest).responseDecodable { (response: DataResponse<GraphQLResponse, AFError>) in
            
            switch response.result {
            case .success(let graphQLResponse):
                
                var departures = [Departure]()
                let calls = graphQLResponse.data.stopPlace.estimatedCalls
                calls.forEach { departure in
                    let formatter = DateFormatter()
                    formatter.dateFormat = self.DATE_TIME_FORMAT
                    guard let time = formatter.date(from: departure.expectedArrivalTime) else {
                        fatalError("Unexpected date format. Got: \(departure.expectedArrivalTime), expected: \(self.DATE_TIME_FORMAT)")
                    }
                    
                    departures.append(Departure(time: time, isRealTime: departure.realtime, destinationName: departure.destinationDisplay.frontText, publicCode: departure.serviceJourney.journeyPattern.line.publicCode))
                }
                
                busStop.departures.departures = departures
            
            case .failure(let error):
                print(error)
                fatalError()
            }
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
