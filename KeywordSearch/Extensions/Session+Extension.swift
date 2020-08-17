//
//  Session+Extension.swift
//  KeywordSearch
//
//  Created by Bozhko Terziev on 17.08.20.
//  Copyright © 2020 Softavail. All rights reserved.
//

import Foundation
import Combine

extension URLSession {
    enum SessionError: Error {
        case statusCode(HTTPURLResponse)
    }

    /// Function that wraps the existing dataTaskPublisher method and attempts to decode the result and publish it
    /// - Parameter request: A URL request object that provides the URL, cache policy, request type, body data or body stream, and so on
    /// - Returns: Publisher that sends a URLSession.Result if the response can be decoded correctly.
    func dataTaskPublisher<T: Decodable>(for request: URLRequest) -> AnyPublisher<T, Error> {
        return self.dataTaskPublisher(for: request)
            .tryMap({ (data, response) -> Data in
                if let response = response as? HTTPURLResponse,
                    (200..<300).contains(response.statusCode) == false {
                    throw SessionError.statusCode(response)
                }

                return data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    /// Function that wraps the existing dataTaskPublisher method and attempts to decode the result and publish it
    /// - Parameter url: The URL to be retrieved.
    /// - Returns: Publisher that sends a URLSession.Result if the response can be decoded correctly.
    func dataTaskPublisher<T: Decodable>(for url: URL) -> AnyPublisher<T, Error> {
        return self.dataTaskPublisher(for: url)
            .tryMap({ (data, response) -> Data in
                if let response = response as? HTTPURLResponse,
                    (200..<300).contains(response.statusCode) == false {
                    throw SessionError.statusCode(response)
                }

                return data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
