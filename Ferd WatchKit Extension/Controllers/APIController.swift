//
//  APIController.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 21/06/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation
import CoreLocation

class APIController: NSObject  {
    
    static let shared = APIController()
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    static let GLOBAL_MAX_STOPS = 30
    static let SEARCH_RADIUS = 800.0
    
    static let REST_API_ENDPOINT = "https://api.entur.io/geocoder/v1/reverse?"
    static let GRAPHQL_API_ENDPOINT = "https://api.entur.io/journey-planner/v2/graphql"
    
    static let API_REQUESTOR_REF = "strandlie_consulting - Ferd"
    
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
    
    func updateNearbyStopsToAPIRequest(coordinate: CLLocation) {

        if var urlComponents = URLComponents(string: APIController.REST_API_ENDPOINT) {
            urlComponents.queryItems = [
                URLQueryItem(name: "point.lat", value: String(coordinate.coordinate.latitude)),
                URLQueryItem(name: "point.lon", value: String(coordinate.coordinate.longitude)),
                URLQueryItem(name: "boundary.circle.radius", value: String(APIController.SEARCH_RADIUS / 1000)),
                URLQueryItem(name: "size", value: String(APIController.GLOBAL_MAX_STOPS)),
                URLQueryItem(name: "layers", value: "venue")
            ]
            
            
            
            guard let url = urlComponents.url else {
                return
            }
            
            var request = URLRequest(url: url)
            request.setValue(APIController.API_REQUESTOR_REF, forHTTPHeaderField: "ET-Client-Name")
            
            dataTask = defaultSession.dataTask(with: request) { [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                
                if let error = error {
                    fatalError("Data task error: " + error.localizedDescription + "\n")
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    guard let nearbyStops = try? JSONDecoder().decode(NearbyStopsResponse.self, from: data) else {
                        fatalError("Decoding error with data: " + data.description)
                    }
                    var stops = [BusStop]()
                    nearbyStops.features.forEach { stop in
                        let busStop = BusStop(id: stop.properties.id, name: stop.properties.name, types: stop.properties.category, longitude: stop.geometry.longitude, latitude: stop.geometry.latitude)
                        
                        stops.append(busStop)
                    }
                    let difference = stops.difference(from: BusStopList.shared.stops)
                    for change in difference {
                        switch(change) {
                            case let .insert(_, newElement, _):
                                DispatchQueue.main.async {
                                    BusStopList.shared.append(newElement)
                                }
                            case let .remove(offset, element, _):
                                DispatchQueue.main.async {
                                    BusStopList.shared.remove(at: offset, for: element)
                                }
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    BusStopList.shared.updateDepartures()
                    BusStopList.shared.updateDistances()
                    AppState.shared.isFetching = false
                }
                
            }
        }
        
        DispatchQueue.main.async {
            AppState.shared.isFetching = true
        }
        dataTask?.resume()
    }

    
    
    //MARK: GraphQL requests
    func getRealtimeDeparturesForAPIRequest(busStop: BusStop, completion: @escaping(() -> Void) = {}) {
        let graphQLQuery = GraphQLQuery(stopID: busStop.id)
        guard let queryString = try? JSONEncoder().encode(graphQLQuery) else {
            fatalError("graphQLQuery does not have the expected format.")
        }
        
        guard let url = URL(string: APIController.GRAPHQL_API_ENDPOINT) else {
            fatalError("GRAPHQL_API_ENDPOINT is not valid string. Got: \(APIController.GRAPHQL_API_ENDPOINT)")
        }
        
        var request = URLRequest(url: url)
        request.httpBody = queryString
        request.httpMethod = "post"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(APIController.API_REQUESTOR_REF, forHTTPHeaderField: "ET-Client-Name")
        
        dataTask = defaultSession.dataTask(with: request) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            
            
            if let error = error {
                fatalError("Data task error: " + error.localizedDescription + "\n")
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                guard let graphQLResponse = try? JSONDecoder().decode(GraphQLResponse.self, from: data) else {
                    fatalError("Decoding GraphQLData error with data: " + data.description)
                }
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
                DispatchQueue.main.async {
                    busStop.departures.departures = departures
                }
                
            }
            BusStopList.shared.updateDistances()
            DispatchQueue.main.async {
                AppState.shared.isFetching = false
            }
        }
        DispatchQueue.main.async {
            AppState.shared.isFetching = true
        }
        dataTask?.resume()
        
        completion()
    }
}
