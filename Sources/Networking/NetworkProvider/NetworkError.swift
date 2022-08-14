//
//  File.swift
//  
//
//  Created by Aleksandr Fadeev on 14.08.2022.
//

import Foundation

enum NetworkError: Error {
    case emptyResponse(error: Error)
    case badResponse(response: URLResponse)
    case badRequest(response: HTTPURLResponse)
    case serverError(response: HTTPURLResponse)
    case badStatusCode(response: HTTPURLResponse)
}
