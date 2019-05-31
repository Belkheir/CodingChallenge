//
//  ISSTrackingManager.swift
//  CodingChallenge
//
//  Created by Belkheir Oussama on 28/05/2019.
//  Copyright © 2019 Belkheir Oussama. All rights reserved.
//

import Foundation

class ISSPassTimeManager {

    let networkingClient: ISSAPIServices

    init(networkingClient: ISSAPIServices) {
        self.networkingClient = networkingClient
    }

    func getPassTimeListFor(latitude: Double, longitude: Double, completionHandler:@escaping ISSCompletionHandler<[ISSPassTime]>) {
        let coordinates = Location(latitude: latitude, longitude: longitude)
        self.networkingClient.getPassTimesList(coordinates: coordinates, numberOfPasses: Macros.numberOfPasses, completionHandler: completionHandler)
    }

    func getStringDateFrom(unixTimeInterval: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let strDate = dateFormatter.string(from: date)

        return strDate
    }

}
