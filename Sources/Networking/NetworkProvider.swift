//
//  NetworkProvider.swift
//  
//
//  Created by Aleksandr Fadeev on 13.08.2022.
//

import Combine
import Foundation

enum NetworkError: Error {
    case emptyResponse(error: Error)
    case badResponse(response: URLResponse)
    case badRequest(response: HTTPURLResponse)
    case serverError(response: HTTPURLResponse)
    case badStatusCode(response: HTTPURLResponse)
}

final class NetworkProvider {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetch(from request: URLRequest) -> AnyPublisher<Data, Error> {
        return urlSession
            .dataTaskPublisher(for: request)
            .mapError { error in
                return NetworkError.emptyResponse(error: error)
            }
            .tryMap { result -> Data in
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw NetworkError.badResponse(response: result.response)
                }
                
                switch httpResponse.statusCode {
                case 200..<300:
                    return result.data
                case 400..<500:
                    throw NetworkError.badRequest(response: httpResponse)
                case 500..<600:
                    throw NetworkError.serverError(response: httpResponse)
                default:
                    throw NetworkError.badStatusCode(response: httpResponse)
                }
            }
            .eraseToAnyPublisher()
    }
}
