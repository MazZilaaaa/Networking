//
//  NetworkProviderProtocol.swift
//  
//
//  Created by Aleksandr Fadeev on 14.08.2022.
//

import Combine
import Foundation

protocol NetworkProviderProtocol {
    func send(_ request: URLRequest) -> AnyPublisher<Data, Error>
}
