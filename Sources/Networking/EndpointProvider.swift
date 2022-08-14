//
//  File.swift
//  
//
//  Created by Aleksandr Fadeev on 14.08.2022.
//

import Combine
import Foundation

final public class EndpointProvider<EndpointType: EndPoint> {
    private let networkProvider: NetworkProviderProtocol
    private let requestBuilder: URLRequestBuilderProtocol
    private let jsonDecoder: JSONDecoder
    
    public convenience init(hostUrl: URL) {
        self.init(
            networkProvider: NetworkProvider(),
            requestBuilder: URLRequestBuilder(hostUrl: hostUrl)
        )
    }
    
    public convenience init(hostUrl: URL, jsonDecoder: JSONDecoder) {
        self.init(
            networkProvider: NetworkProvider(),
            requestBuilder: URLRequestBuilder(hostUrl: hostUrl),
            jsonDecoder: jsonDecoder
        )
    }
    
    init(
        networkProvider: NetworkProviderProtocol,
        requestBuilder: URLRequestBuilderProtocol,
        jsonDecoder: JSONDecoder = JSONDecoder()
    ) {
        self.networkProvider = networkProvider
        self.requestBuilder = requestBuilder
        self.jsonDecoder = jsonDecoder
    }
    
    public func execute<T: Decodable>(endpoint: EndpointType) -> AnyPublisher<T, Error> {
        return send(endpoint: endpoint)
            .decode(type: T.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
    
    public func execute(endpoint: EndpointType) -> AnyPublisher<Void, Error> {
        return send(endpoint: endpoint)
            .map { _ in
                return ()
            }
            .eraseToAnyPublisher()
    }
    
    private func send(endpoint: EndpointType) -> AnyPublisher<Data, Error> {
        return requestBuilder
            .buildRequestPublisher(endpoint)
            .flatMap { [networkProvider] request in
                networkProvider.send(request)
            }
            .eraseToAnyPublisher()
    }
}
