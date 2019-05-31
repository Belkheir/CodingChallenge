//
//  PassengersPayloadResponse.swift
//  CodingChallenge
//
//  Created by Belkheir Oussama on 29/05/2019.
//  Copyright © 2019 Belkheir Oussama. All rights reserved.
//

import Foundation

public struct PassengersPayloadResponse: Codable {
    let message: String
    let number: Int
    let people: [ISSPassenger]
}
