//
//  ISSPassengersResponse.swift
//  CodingChallenge
//
//  Created by Belkheir Oussama on 29/05/2019.
//  Copyright © 2019 Belkheir Oussama. All rights reserved.
//

import Foundation

public struct ISSPassengersPayload: Codable {
    let message: String
    let response: [ISSPassTime]
}
