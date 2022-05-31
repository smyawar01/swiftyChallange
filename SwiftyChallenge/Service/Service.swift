//
//  Service.swift
//  SwiftyChallenge
//
//  Created by Monish Syed  on 10/08/2020.
//  Copyright © 2020 Monish Syed . All rights reserved.
//

import Foundation

/// Create a concrete request type for each request your app supports
/// Usage:
/// ```
/// class CareemImageRequest: Request {
///     var urlRequest: URLRequest {
///         return request
///     }
/// }
/// ```
protocol Request {
    var urlRequest: URLRequest { get }
}

/// An abstract service type that can have multiple implementation for example - a NetworkService that gets a resource from the Network or a DiskService that gets a resource from Disk
protocol Service {
    func get(request: Request, completion: @escaping (Result<Data, Error>) -> Void)
}

/// A concrete implementation of Service class responsible for getting a Network resource
final class NetworkService: Service {
    
    let session = URLSession(configuration: .default)
    enum ServiceError: Error {
        case noData
        case invalidUrl
        case invalidJson
    }
    
    func get(request: Request, completion: @escaping (Result<Data, Error>) -> Void) {
        session.dataTask(with: request.urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(ServiceError.noData))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
