//
//  URLRequestBuilderError.swift
//  
//
//  Created by Aleksandr Fadeev on 13.08.2022.
//

import Combine
import Foundation

final class URLRequestBuilder {
    let hostUrl: URL
    
    init(hostUrl: URL) {
        self.hostUrl = hostUrl
    }
    
    init(hostString: String) throws {
        guard let host = URL(string: hostString) else {
            throw BuildingRequestError.invalidHostString
        }
        
        self.hostUrl = host
    }
}

extension URLRequestBuilder: URLRequestBuilderProtocol {
    func buildRequest(_ endpoint: EndPoint) throws -> URLRequest {
        var urlComponents = URLComponents(url: hostUrl, resolvingAgainstBaseURL: false)
        urlComponents?.path = endpoint.path
        
        switch endpoint.method {
        case let .get(queryItems), let .head(queryItems), let .delete(queryItems):
            urlComponents?.queryItems = queryItems
        default:
            break
        }
        
        guard let url = urlComponents?.url else {
            throw BuildingRequestError.invalidUrlComponents(description: "check \(endpoint.self) path or queryItems")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        endpoint.headers?.forEach { header in
            request.addValue(header.value, forHTTPHeaderField: header.key.rawValue)
        }
        
        switch endpoint.method {
        case let .post(body), let .put(body):
            request.httpBody = body
        default:
            break
        }
        
        return request
    }
    
    func buildRequestPublisher(_ endpoint: EndPoint) -> AnyPublisher<URLRequest, Error> {
        Just(())
            .tryMap { try buildRequest(endpoint) }
            .eraseToAnyPublisher()
    }
}
