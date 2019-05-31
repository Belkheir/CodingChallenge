//
//  Location.swift
//  CodingChallenge
//
//  Created by Belkheir Oussama on 29/05/2019.
//  Copyright © 2019 Belkheir Oussama. All rights reserved.
//

import Foundation
import CoreLocation

public struct Location {
    let latitude: Double
    let longitude: Double

    func isVisible(for location: Location, inside radius: Double) -> Bool {
        let locationA = CLLocation(latitude: latitude, longitude: longitude)
        let locationB = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let  distance = locationA.distance(from: locationB)

        return distance <= radius
    }
}


