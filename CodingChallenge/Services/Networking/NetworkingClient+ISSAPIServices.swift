//
//  NetworkingClient+ISSAPIServices.swift
//  CodingChallenge
//
//  Created by Belkheir Oussama on 29/05/2019.
//  Copyright © 2019 Belkheir Oussama. All rights reserved.
//

import Foundation

extension NetworkingClient: ISSAPIServices {

    public func getISSLiveLocation(completionHandler:@escaping (ISSPosition?, NetworkingError?) -> Void) {
        let urlPath = Macros.baseURL + Macros.ISSLocationPath
        self.performRequest(urlString: urlPath, parameters: nil) { (data, error) in
            if let data = data, data.isEmpty == false {
                do {
                    let payloadResponse = try JSONDecoder().decode(ISSPositionPayload.self, from: data)
                    let position = payloadResponse.iss_position
                    completionHandler(position, nil)
                } catch  {
                    completionHandler(nil, NetworkingError.modelIntegrityViolation)
                }
            }

        }
    }

    public func getPassengersList(completionHandler:@escaping ([ISSPassenger]?, NetworkingError?) -> Void) {
        let urlPath = Macros.baseURL + Macros.astrosPath
        self.performRequest(urlString: urlPath, parameters: nil) { (data, error) in
            if let data = data, data.isEmpty == false {
                do {
                    let payloadResponse = try JSONDecoder().decode(PassengersPayloadResponse.self, from: data)
                    let people = payloadResponse.people
                    completionHandler(people, nil)
                } catch  {
                    completionHandler(nil, NetworkingError.modelIntegrityViolation)
                }
            }

        }

    }

    public func getPassTimesList(coordinates: Location, numberOfPasses: Int, completionHandler:@escaping ([ISSPassTime]?, NetworkingError?) -> Void) {
        let urlPath = Macros.baseURL + Macros.issPashPath
        var parameters = [String: String]()
        parameters["lat"] = "\(coordinates.latitude)"
        parameters["lon"] = "\(coordinates.longitude)"
        parameters["n"] = "\(numberOfPasses)"

        self.performRequest(urlString: urlPath, parameters: parameters) { (data, error) in
            if let data = data, data.isEmpty == false {

                do {
                    let payloadResponse = try JSONDecoder().decode(ISSPassengersPayload.self, from: data)
                    let passTimes = payloadResponse.response
                    completionHandler(passTimes, nil)
                } catch  {
                    completionHandler(nil, NetworkingError.modelIntegrityViolation)
                }
            }

        }
    }

}
