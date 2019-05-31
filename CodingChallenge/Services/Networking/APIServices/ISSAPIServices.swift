//
//  ISSAPIServices.swift
//  CodingChallenge
//
//  Created by Belkheir Oussama on 29/05/2019.
//  Copyright © 2019 Belkheir Oussama. All rights reserved.
//

import Foundation
public typealias ISSCompletionHandler<T: Decodable> = (T?, NetworkingError?) -> Void

public protocol ISSAPIServices {
    func getISSLiveLocation(completionHandler:@escaping ISSCompletionHandler<ISSPosition>)
    func getPassengersList(completionHandler:@escaping ISSCompletionHandler<[ISSPassenger]>)
    func getPassTimesList(coordinates: Location, numberOfPasses: Int, completionHandler:@escaping ISSCompletionHandler<[ISSPassTime]>)
}
