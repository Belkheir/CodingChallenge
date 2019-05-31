//
//  ISSPassengersManager.swift
//  CodingChallenge
//
//  Created by Belkheir Oussama on 28/05/2019.
//  Copyright © 2019 Belkheir Oussama. All rights reserved.
//

import Foundation

class ISSPassengersManager {

    let networkingClient: ISSAPIServices

    init(networkingClient: ISSAPIServices) {
        self.networkingClient = networkingClient
    }

    func getAstronostsList(completionHandler:@escaping ISSCompletionHandler<[ISSPassenger]>) {
        self.networkingClient.getPassengersList(completionHandler: completionHandler)
    }

}
