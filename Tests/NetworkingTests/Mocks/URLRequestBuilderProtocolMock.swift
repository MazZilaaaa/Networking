//
//  File.swift
//  
//
//  Created by Aleksandr Fadeev on 14.08.2022.
//

import Combine
import Foundation

@testable import Networking

final class URLRequestBuilderProtocolMock: URLRequestBuilderProtocol {
    
    var hostUrl: URL
    
    var receivedEndpoint: EndPoint!
    var buildReuestMocked: URLRequest!
    var buildRequestPublisherMock: AnyPublisher<URLRequest, Error>!
    
    init(hostUrl: URL) {
        self.hostUrl = hostUrl
    }
    
    func buildRequestPublisher(_ endpoint: EndPoint) -> AnyPublisher<URLRequest, Error> {
        receivedEndpoint = endpoint
        
        return buildRequestPublisherMock
    }
    
    func buildRequest(_ endpoint: EndPoint) throws -> URLRequest {
        receivedEndpoint = endpoint
        
        return buildReuestMocked
    }
}
