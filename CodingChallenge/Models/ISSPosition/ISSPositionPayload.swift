//
//  ISSLocation.swift
//  CodingChallenge
//
//  Created by Belkheir Oussama on 29/05/2019.
//  Copyright © 2019 Belkheir Oussama. All rights reserved.
//

import Foundation

struct ISSPositionPayload: Codable {
    let message: String
    let timestamp: Double
    let iss_position: ISSPosition
}
