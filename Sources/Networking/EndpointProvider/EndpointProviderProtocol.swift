//
//  EndpointProviderProtocol.swift
//  
//
//  Created by Aleksandr Fadeev on 21.08.2022.
//

import Combine
import Foundation

public protocol EndpointProviderProtocol {
    associatedtype EndpointType: EndPoint
    
    func load<T: Decodable>(endpoint: EndpointType) -> AnyPublisher<T, Error>
    func load(endpoint: EndpointType) -> AnyPublisher<Data, Error>
}
