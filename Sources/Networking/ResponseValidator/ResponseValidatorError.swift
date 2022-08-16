//
//  ResponseValidatorError.swift
//  
//
//  Created by Aleksandr Fadeev on 16.08.2022.
//

import Foundation

enum ResponseValidatorError: Error, Equatable {
    case redirect(response: URLResponse)
    case badResponse(response: URLResponse)
    case badRequest(response: HTTPURLResponse)
    case serverError(response: HTTPURLResponse)
    case badStatusCode(response: HTTPURLResponse)
}
