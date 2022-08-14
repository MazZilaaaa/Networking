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
        
        URLProtocolMock.responseMock = nil
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
    
    func test_send_200() {
        // given
        let request: URLRequest = .stub()
        let data: Data? = "json".data(using: .utf8)
        
        URLProtocolMock.responseMock = .ok(data: data)
        var receivedData: Data?
        var receivedCompletion: Subscribers.Completion<Error>?
        let expectation = expectation(description: "test_send_200")
        
        // when
        provider
            .send(request)
            .sink { completion in
                receivedCompletion = completion
                expectation.fulfill()
            } receiveValue: { data in
                receivedData = data
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 0.5)
        
        // then
        XCTAssertEqual(receivedData, data)
        XCTAssertEqual(URLProtocolMock.receivedCanonicalRequest, request)
        
        guard case .finished = receivedCompletion else {
            XCTFail()
            return
        }
    }
    
    func test_send_400() {
        // given
        let url = URL(string: "https://github.com")!
        let request = URLRequest(url: url)
        var receivedCompletion: Subscribers.Completion<Error>?
        URLProtocolMock.responseMock = .badRequest()
        
        let expectation = expectation(description: "test_send_400")
        
        // when
        provider
            .send(request)
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
    
    func test_send_500() {
        // given
        let url = URL(string: "https://github.com")!
        let request = URLRequest(url: url)
        var receivedCompletion: Subscribers.Completion<Error>?
        URLProtocolMock.responseMock = .serverError()
        
        let expectation = expectation(description: "test_send_500")
        
        // when
        provider
            .send(request)
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
    
    func test_send_600() {
        // given
        let url = URL(string: "https://github.com")!
        let request = URLRequest(url: url)
        var receivedCompletion: Subscribers.Completion<Error>?
        URLProtocolMock.responseMock = .badStatusCode()
        
        let expectation = expectation(description: "test_send_600")
        
        // when
        provider
            .send(request)
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
    
    func test_send_error() {
        // given
        let url = URL(string: "https://github.com")!
        let request = URLRequest(url: url)
        var receivedCompletion: Subscribers.Completion<Error>?
        URLProtocolMock.error = NetworkProviderTestsError.test
        
        let expectation = expectation(description: "test_send_error")
        
        // when
        provider
            .send(request)
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
