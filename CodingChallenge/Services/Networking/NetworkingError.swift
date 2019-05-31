//
//  NetworkingError.swift
//  CodingChallenge
//
//  Created by Belkheir Oussama on 29/05/2019.
//  Copyright © 2019 Belkheir Oussama. All rights reserved.
//

import Foundation

public enum NetworkingError: Error {
    case invalidURL
    case requestFailed(URL?, Error)
    case invalidResponse
    case modelIntegrityViolation
}

extension NetworkingError: CustomNSError {
    public var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "The URL is invalid"
        case .requestFailed:
            return "An error has occured while fetching the informations from the server, please try again"
        case .invalidResponse:
            return "The response is invalid"
        case .modelIntegrityViolation:
            return "An error has occured while parsing the data"
        }
    }
}
