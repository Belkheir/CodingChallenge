//
//  NetworkingClient.swift
//  CodingChallenge
//
//  Created by Belkheir Oussama on 29/05/2019.
//  Copyright © 2019 Belkheir Oussama. All rights reserved.
//

import Foundation

public class NetworkingClient {
    static let sharedInstance = NetworkingClient()
    typealias NetworkingClientResult = (Data?, NetworkingError?) -> Void

    private init() {}

    func performRequest(urlString: String, parameters: [String: String]?, completionHandler: @escaping NetworkingClientResult) {
        var finalURL: URL

        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            completionHandler(nil, NetworkingError.invalidURL)
            return
        }

        finalURL = url

        if let urlParams = parameters, urlParams.count > 0  {
            var queryItems: [URLQueryItem] = []
            var urlComps = URLComponents(string: urlString)!

            urlParams.forEach { (key, value) in
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            urlComps.queryItems = queryItems
            finalURL = urlComps.url!
        }

        let urlRequest = URLRequest(url: finalURL)

        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            var networkingError: NetworkingError?

            defer {
                completionHandler(data, networkingError)
            }
            
            guard error == nil else {
                networkingError = NetworkingError.requestFailed(url, error!)
                return
            }

            guard
                let httpResponse = response as? HTTPURLResponse,
                200...204 ~= httpResponse.statusCode
                else {
                    networkingError = NetworkingError.invalidResponse
                    return
            }

        }
        task.resume()
    }
}
