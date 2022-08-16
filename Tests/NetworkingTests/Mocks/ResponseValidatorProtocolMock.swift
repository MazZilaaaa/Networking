//
//  ResponseValidatorProtocolMock.swift
//  
//
//  Created by Aleksandr Fadeev on 16.08.2022.
//

import Foundation
@testable import Networking

final class ResponseValidatorProtocolMock: ResponseValidatorProtocol {
    
    var throwError: Error?
    var receivedResponse: URLResponse?
    
    func validate(response: URLResponse) throws {
        receivedResponse = response
        
        if let throwError = throwError {
            throw throwError
        }
    }
}
