//
//  NetworkProviderTests.swift
//
//
//  Created by Aleksandr Fadeev on 13.08.2022.
//

import Combine
import XCTest

@testable import Networking

private enum NetworkProviderTestsError: Error {
    case test
}

final class NetworkProviderTests: XCTestCase {
    var provider: NetworkProvider!
    
    private var subscriptions: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        
        URLProtocolMock.statusCode = nil
        URLProtocolMock.error = nil
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolMock.self]
        
        let urlSession = URLSession(configuration: configuration)
        provider = NetworkProvider(urlSession: urlSession)
    }
    
    override func tearDown() {
        provider = nil
        
        super.tearDown()
    }
    
    func test_fetch_200() {
        // given
        let url = URL(string: "https://github.com")!
        let request = URLRequest(url: url)
        URLProtocolMock.statusCode = 200
        
        var receivedData: Data?
        var receivedCompletion: Subscribers.Completion<Error>?
        
        let expectation = expectation(description: "test_fetch_200")
        
        // when
        provider
            .fetch(from: request)
            .sink { completion in
                receivedCompletion = completion
                expectation.fulfill()
            } receiveValue: { data in
                receivedData = data
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 0.5)
        
        // then
        XCTAssertEqual(URLProtocolMock.receivedCanonicalRequest, request)
        
        guard case .finished = receivedCompletion else {
            XCTFail()
            return
        }
    }
    
    func test_fetch_400() {
        // given
        let url = URL(string: "https://github.com")!
        let request = URLRequest(url: url)
        var receivedCompletion: Subscribers.Completion<Error>?
        URLProtocolMock.statusCode = 400
        
        let expectation = expectation(description: "test_fetch_400")
        
        // when
        provider
            .fetch(from: request)
            .sink { completion in
                receivedCompletion = completion
                expectation.fulfill()
            } receiveValue: { _ in
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 0.5)
        
        // then
        guard case let .failure(error) = receivedCompletion else {
            XCTFail()
            return
        }
        
        guard case let .badRequest(receivedResponse) = error as? NetworkError else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(URLProtocolMock.receivedCanonicalRequest, request)
        XCTAssertEqual(receivedResponse.statusCode, 400)
    }
    
    func test_fetch_500() {
        // given
        let url = URL(string: "https://github.com")!
        let request = URLRequest(url: url)
        var receivedCompletion: Subscribers.Completion<Error>?
        URLProtocolMock.statusCode = 500
        
        let expectation = expectation(description: "test_fetch_500")
        
        // when
        provider
            .fetch(from: request)
            .sink { completion in
                receivedCompletion = completion
                expectation.fulfill()
            } receiveValue: { _ in
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 0.5)
        
        // then
        guard case let .failure(error) = receivedCompletion else {
            XCTFail()
            return
        }
        
        guard case let .serverError(receivedResponse) = error as? NetworkError else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(URLProtocolMock.receivedCanonicalRequest, request)
        XCTAssertEqual(receivedResponse.statusCode, 500)
    }
    
    func test_fetch_600() {
        // given
        let url = URL(string: "https://github.com")!
        let request = URLRequest(url: url)
        var receivedCompletion: Subscribers.Completion<Error>?
        URLProtocolMock.statusCode = 600
        
        let expectation = expectation(description: "test_fetch_600")
        
        // when
        provider
            .fetch(from: request)
            .sink { completion in
                receivedCompletion = completion
                expectation.fulfill()
            } receiveValue: { _ in
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 0.5)
        
        // then
        guard case let .failure(error) = receivedCompletion else {
            XCTFail()
            return
        }
        
        guard case let .badStatusCode(receivedResponse) = error as? NetworkError else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(URLProtocolMock.receivedCanonicalRequest, request)
        XCTAssertEqual(receivedResponse.statusCode, 600)
    }
    
    func test_fetch_error() {
        // given
        let url = URL(string: "https://github.com")!
        let request = URLRequest(url: url)
        var receivedCompletion: Subscribers.Completion<Error>?
        URLProtocolMock.error = NetworkProviderTestsError.test
        
        let expectation = expectation(description: "test_fetch_error")
        
        // when
        provider
            .fetch(from: request)
            .sink { completion in
                receivedCompletion = completion
                expectation.fulfill()
            } receiveValue: { _ in
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 0.5)
        
        // then
        guard case let .failure(error) = receivedCompletion else {
            XCTFail()
            return
        }
        
        guard case .emptyResponse = error as? NetworkError else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(URLProtocolMock.receivedCanonicalRequest, request)
    }
}
