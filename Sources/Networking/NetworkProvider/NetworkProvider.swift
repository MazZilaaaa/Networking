//
//  NetworkProvider.swift
//  
//
//  Created by Aleksandr Fadeev on 13.08.2022.
//

import Combine
import Foundation

final class NetworkProvider {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
}

extension NetworkProvider: NetworkProviderProtocol {
    func send(_ request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
        return urlSession
            .dataTaskPublisher(for: request)
            .mapError { error in
                return NetworkError.connectionError(reason: error)
            }
            .eraseToAnyPublisher()
    }
}
