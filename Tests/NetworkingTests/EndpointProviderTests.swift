//
//  File.swift
//  
//
//  Created by Aleksandr Fadeev on 14.08.2022.
//

import Combine
import XCTest
@testable import Networking

private struct TestModel: Decodable {
    let title: String
}

final class EndpointProviderTests: XCTestCase {
    private var provider: EndpointProvider<EndpointMock>!
    private var networkProvider: NetworkProviderProtocolMock!
    private var requestBuilder: URLRequestBuilderProtocolMock!
    
    private var subscriptions: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        
        networkProvider = NetworkProviderProtocolMock()
        requestBuilder = URLRequestBuilderProtocolMock()
        provider = EndpointProvider(networkProvider: networkProvider, requestBuilder: requestBuilder)
    }
    
    func test_endpointProvider_void() {
        // given
        let request: URLRequest = .stub()
        let endpoint = EndpointMock.createEndpoint()
        requestBuilder.buildRequestPublisherMock = Just(request)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        networkProvider.sendPublisher = Just("json".data(using: .utf8)!)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let expectation = expectation(description: "test_endpointProvider")
        
        // when
        provider.execute(endpoint: endpoint)
            .sink { _ in
                expectation.fulfill()
            } receiveValue: { _ in
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 0.5)
        
        // then
        XCTAssertEqual(networkProvider.receivedRequest, request)
        XCTAssertEqual(requestBuilder.receivedEndpoint.path, endpoint.path)
        XCTAssertEqual(requestBuilder.receivedEndpoint.method, endpoint.method)
        XCTAssertEqual(requestBuilder.receivedEndpoint.headers, endpoint.headers)
    }
    
    func test_endpointProvider_result() {
        // given
        let request: URLRequest = .stub()
        let endpoint = EndpointMock.createEndpoint()
        requestBuilder.buildRequestPublisherMock = Just(request)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        networkProvider.sendPublisher = Just("{\"title\": \"title\"}".data(using: .utf8)!)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let expectation = expectation(description: "test_endpointProvider")
        var receivedResult: TestModel?
        
        // when
        provider.execute(endpoint: endpoint)
            .sink { _ in
                expectation.fulfill()
            } receiveValue: { result in
                receivedResult = result
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 0.5)
        
        // then
        XCTAssertEqual(networkProvider.receivedRequest, request)
        XCTAssertEqual(requestBuilder.receivedEndpoint.path, endpoint.path)
        XCTAssertEqual(requestBuilder.receivedEndpoint.method, endpoint.method)
        XCTAssertEqual(requestBuilder.receivedEndpoint.headers, endpoint.headers)
        XCTAssertEqual(receivedResult?.title, "title")
    }
}
