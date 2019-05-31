//
//  LocationHandler.swift
//  CodingChallenge
//
//  Created by Belkheir Oussama on 29/05/2019.
//  Copyright © 2019 Belkheir Oussama. All rights reserved.
//

import Foundation

class ISSLocationManager {

    let networkingClient: ISSAPIServices
    var timer = Timer()
    init(networkingClient: ISSAPIServices) {
        self.networkingClient = networkingClient
    }

    func moveISS(completionHandler:@escaping ((Location, NetworkingError?) -> Void)) {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.networkingClient.getISSLiveLocation(completionHandler: { (position, error) in
                guard let position = position,
                    let latitude = Double(position.latitude),
                    let longitude = Double(position.longitude) else { return }

                let location = Location(latitude: latitude, longitude: longitude)
                completionHandler(location, error)
            })
        }
    }
 
}
