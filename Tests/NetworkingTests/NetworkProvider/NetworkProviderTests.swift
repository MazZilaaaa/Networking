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
        
        guard case .connectionError = error as? NetworkError else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(URLProtocolMock.receivedCanonicalRequest, request)
    }
}
