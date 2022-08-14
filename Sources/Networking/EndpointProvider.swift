//
//  File.swift
//  
//
//  Created by Aleksandr Fadeev on 14.08.2022.
//

import Combine
import Foundation

final public class EndpointProvider {
    private let networkProvider: NetworkProviderProtocol
    private let requestBuilder: URLRequestBuilderProtocol
    private let jsonDecoder: JSONDecoder
    
    init(
        networkProvider: NetworkProviderProtocol,
        requestBuilder: URLRequestBuilderProtocol,
        jsonDecoder: JSONDecoder = JSONDecoder()
    ) {
        self.networkProvider = networkProvider
        self.requestBuilder = requestBuilder
        self.jsonDecoder = jsonDecoder
    }
    
    func send<T: Decodable>(endpoint: EndPoint) -> AnyPublisher<T, Error> {
        requestBuilder
            .buildRequestPublisher(endpoint)
            .flatMap { [networkProvider] request in
                networkProvider.send(request)
            }
            .decode(type: T.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
}
