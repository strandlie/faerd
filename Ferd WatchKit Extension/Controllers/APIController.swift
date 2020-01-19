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
    
    static let shared = APIController()
    
    static let GLOBAL_MAX_STOPS = 30
    static let SEARCH_RADIUS = 800.0
    
    static let REST_API_ENDPOINT = "https://api.entur.io/geocoder/v1/reverse?"
    static let GRAPHQL_API_ENDPOINT = "https://api.entur.io/journey-planner/v2/graphql"
    
    static let API_REQUESTOR_REF = "strandlie_development - BussTid"
    
    static let DATE_TIME_FORMAT = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    
    
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

        // Set global fetching state
        AppState.shared.isFetching = true
        
        let parameters: Parameters = [
            "point.lat": coordinate.coordinate.latitude,
            "point.lon": coordinate.coordinate.longitude,
            "boundary.circle.radius": APIController.SEARCH_RADIUS / 1000,
            "size": limitStops ?? APIController.GLOBAL_MAX_STOPS,
            "layers": "venue"
        ]
        
        let headers: HTTPHeaders = [
            "ET-Client-Name": APIController.API_REQUESTOR_REF
        ]
        
        AF.request(APIController.REST_API_ENDPOINT, parameters: parameters, headers: headers).responseDecodable { (response: DataResponse<NearbyStopsResponse, AFError>) in
            switch response.result {
            case .success(let nearbyStops):
                var stops = [BusStop]()
                nearbyStops.features.forEach { stop in
                    let busStop = BusStop(id: stop.properties.id, name: stop.properties.name, types: stop.properties.category, longitude: stop.geometry.longitude, latitude: stop.geometry.latitude)
                    
                    stops.append(busStop)
                }
                let difference = stops.difference(from: BusStopList.shared.stops)
                for change in difference {
                    switch(change) {
                        case let .insert(_, newElement, _):
                            BusStopList.shared.append(newElement)
                        case let .remove(offset, element, _):
                            BusStopList.shared.remove(at: offset, for: element)
                    }
                }
                
            case .failure(let value):
                print("Failure!")
                print("Value: \(value)")
                
            }
            AppState.shared.isFetching = false
            
        }
        
    }
    
    
    //MARK: GraphQL requests
    
    func getRealtimeDeparturesForAPIRequest(busStop: BusStop, completion: @escaping(() -> Void) = {}) {
        AppState.shared.isFetching = true
        
        let graphQLQuery = GraphQLQuery(stopID: busStop.id)
        guard let queryString = try? JSONEncoder().encode(graphQLQuery) else {
            fatalError("graphQLQuery does not have the expected format.")
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "ET-Client-Name": APIController.API_REQUESTOR_REF
        ]
        
        guard let url = URL(string: APIController.GRAPHQL_API_ENDPOINT) else {
            fatalError("GRAPHQL_API_ENDPOINT is not valid string. Got: \(APIController.GRAPHQL_API_ENDPOINT)")
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
                    formatter.dateFormat = APIController.DATE_TIME_FORMAT
                    guard let time = formatter.date(from: departure.expectedArrivalTime) else {
                        fatalError("Unexpected date format. Got: \(departure.expectedArrivalTime), expected: \(APIController.DATE_TIME_FORMAT)")
                    }
                    
                    departures.append(Departure(time: time, isRealTime: departure.realtime, destinationName: departure.destinationDisplay.frontText, publicCode: departure.serviceJourney.journeyPattern.line.publicCode))
                }
                busStop.departures.departures = departures
            
            case .failure(let error):
                print("Result: \(response.result)")
                print(error)
                fatalError()
            }
            AppState.shared.isFetching = false
            completion()
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
