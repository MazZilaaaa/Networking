//
//  ResponseValidator.swift
//  
//
//  Created by Aleksandr Fadeev on 16.08.2022.
//

import Combine
import Foundation

final class ResponseValidator {
}

extension ResponseValidator: ResponseValidatorProtocol {
    func validate(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ResponseValidatorError.badResponse(response: response)
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            break
        case 300..<400:
            throw ResponseValidatorError.redirect(response: httpResponse)
        case 400..<500:
            throw ResponseValidatorError.badRequest(response: httpResponse)
        case 500..<600:
            throw ResponseValidatorError.serverError(response: httpResponse)
        default:
            throw ResponseValidatorError.badStatusCode(response: httpResponse)
        }
    }
}
