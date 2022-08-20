//
//  EndpointProvider.swift
//  
//
//  Created by Aleksandr Fadeev on 14.08.2022.
//

import Combine
import Foundation

final public class EndpointProvider<EndpointType: EndPoint> {
    private let networkProvider: NetworkProviderProtocol
    private let requestBuilder: URLRequestBuilderProtocol
    private let responseValidator: ResponseValidatorProtocol
    private let jsonDecoder: JSONDecoder
    
    public convenience init(hostUrl: URL) {
        self.init(
            networkProvider: NetworkProvider(),
            requestBuilder: URLRequestBuilder(hostUrl: hostUrl),
            responseValidator: ResponseValidator()
        )
    }
    
    public convenience init(hostUrl: URL, jsonDecoder: JSONDecoder) {
        self.init(
            networkProvider: NetworkProvider(),
            requestBuilder: URLRequestBuilder(hostUrl: hostUrl),
            responseValidator: ResponseValidator(),
            jsonDecoder: jsonDecoder
        )
    }
    
    init(
        networkProvider: NetworkProviderProtocol,
        requestBuilder: URLRequestBuilderProtocol,
        responseValidator: ResponseValidatorProtocol,
        jsonDecoder: JSONDecoder = JSONDecoder()
    ) {
        self.networkProvider = networkProvider
        self.requestBuilder = requestBuilder
        self.responseValidator = responseValidator
        self.jsonDecoder = jsonDecoder
    }
    
    public func load<T: Decodable>(endpoint: EndpointType) -> AnyPublisher<T, Error> {
        return load(endpoint: endpoint)
            .print()
            .decode(type: T.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
    
    public func load(endpoint: EndpointType) -> AnyPublisher<Data, Error> {
        return requestBuilder
            .buildRequestPublisher(endpoint)
            .flatMap { [networkProvider] request in
                networkProvider.send(request)
            }
            .tryMap { [responseValidator] data, response in
                if endpoint.errorValidationType != ErrorValidationType.none {
                    try responseValidator.validate(response: response)
                }
                
                return data
            }
            .eraseToAnyPublisher()
    }
}
