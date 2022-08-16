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
    
    var sendPublisher: AnyPublisher<(data: Data, response: URLResponse), Error>!
    func send(_ request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
        receivedRequest = request
        
        return sendPublisher
    }
}
