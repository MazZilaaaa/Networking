//
//  NetworkProviderProtocolMock+.swift
//  
//
//  Created by Aleksandr Fadeev on 14.08.2022.
//

import Combine
import Foundation

@testable import Networking

final class NetworkProviderProtocolMock: NetworkProviderProtocol {
    var receivedRequest: URLRequest?
    
    var sendPublisher: AnyPublisher<Data, Error>!
    func send(_ request: URLRequest) -> AnyPublisher<Data, Error> {
        receivedRequest = request
        
        return sendPublisher
    }
}
