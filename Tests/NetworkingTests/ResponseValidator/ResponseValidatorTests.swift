//
//  File.swift
//  
//
//  Created by Aleksandr Fadeev on 16.08.2022.
//

import XCTest
@testable import Networking

final class ResponseValidatorTests: XCTestCase {
    var responseValidator: ResponseValidatorProtocol!
    
    override func setUp() {
        super.setUp()
        
        responseValidator = ResponseValidator()
    }
    
    func test_validate_unvalidResponse() {
        // given
        let response: URLResponse = .stub()
        
        // when
        XCTAssertThrowsError(try responseValidator.validate(response: response)) { error in
            guard case let ResponseValidatorError.badResponse(response: httpResponse) = error else {
                return XCTFail("error should be \(String(describing: ResponseValidatorError.badResponse))")
            }
            
            XCTAssertEqual(httpResponse, response)
        }
    }
    
    func test_validate_redirectError() {
        // given
        let response: HTTPURLResponse = .stub(statusCode: 300)
        
        // when
        XCTAssertThrowsError(try responseValidator.validate(response: response)) { error in
            guard case let ResponseValidatorError.redirect(response: httpResponse) = error else {
                return XCTFail("error should be \(String(describing: ResponseValidatorError.redirect))")
            }
            
            XCTAssertEqual(httpResponse, response)
        }
    }
    
    func test_validate_badRequestError() {
        // given
        let response: HTTPURLResponse = .stub(statusCode: 400)
        
        // when
        XCTAssertThrowsError(try responseValidator.validate(response: response)) { error in
            guard case let ResponseValidatorError.badRequest(response: httpResponse) = error else {
                return XCTFail("error should be \(String(describing: ResponseValidatorError.badRequest))")
            }
            
            XCTAssertEqual(httpResponse, response)
        }
    }
    
    func test_validate_serverError() {
        // given
        let response: HTTPURLResponse = .stub(statusCode: 500)
        
        // when
        XCTAssertThrowsError(try responseValidator.validate(response: response)) { error in
            guard case let ResponseValidatorError.serverError(response: httpResponse) = error else {
                return XCTFail("error should be \(String(describing: ResponseValidatorError.serverError))")
            }
            
            XCTAssertEqual(httpResponse, response)
        }
    }
    
    func test_validate_badStatusCode() {
        // given
        let response: HTTPURLResponse = .stub(statusCode: 600)
        
        // when
        XCTAssertThrowsError(try responseValidator.validate(response: response)) { error in
            guard case let ResponseValidatorError.badStatusCode(response: httpResponse) = error else {
                return XCTFail("error should be \(String(describing: ResponseValidatorError.badStatusCode))")
            }
            
            XCTAssertEqual(httpResponse, response)
        }
    }
}
