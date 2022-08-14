//
//  File.swift
//  
//
//  Created by Aleksandr Fadeev on 14.08.2022.
//

import Combine
import Foundation

protocol URLRequestBuilderProtocol {
    var hostUrl: URL { get }
    
    func buildRequest(_ endpoint: EndPoint) throws -> URLRequest
    func buildRequestPublisher(_ endpoint: EndPoint) -> AnyPublisher<URLRequest, Error>
}
