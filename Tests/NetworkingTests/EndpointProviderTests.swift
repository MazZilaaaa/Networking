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
    
    func test_executeWithResult() {
        // given
        let request: URLRequest = .stub()
        let endpoint = EndpointMock.createEndpoint()
        requestBuilder.buildRequestPublisherMock = Just(request)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        networkProvider.sendPublisher = Just("{\"title\": \"title\"}".data(using: .utf8)!)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let expectation = expectation(description: "test_endpointProvider_result")
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
    
    func test_executeWithResult_mappingError() {
        // given
        requestBuilder.buildRequestPublisherMock = Just(.stub())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        networkProvider.sendPublisher = Just("{\"description\": \"description\"}".data(using: .utf8)!)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let expectation = expectation(description: "test_endpointProvider_mappingError")
        var receivedCompletion: Subscribers.Completion<Error>?
        
        // when
        provider.execute(endpoint: .createEndpoint())
            .sink { completion in
                receivedCompletion = completion
                expectation.fulfill()
            } receiveValue: { (result: TestModel) in
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 0.5)
        
        // then
        guard case let .failure(error) = receivedCompletion else {
            XCTFail()
            return
        }
        
        XCTAssertNotNil(error as? DecodingError)
    }
    
    func test_executeWithResult_networkError() {
        test_executeWithResult_networkError(.emptyResponse(error: ErrorMock.mock))
        test_executeWithResult_networkError(.badResponse(response: .stub()))
        test_executeWithResult_networkError(.badRequest(response: .stub()))
        test_executeWithResult_networkError(.serverError(response: .stub()))
        test_executeWithResult_networkError(.badStatusCode(response: .stub()))
    }
    
    func test_executeWithResult_networkError(_ error: NetworkError) {
        // given
        requestBuilder.buildRequestPublisherMock = Just(.stub())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        networkProvider.sendPublisher = Fail<Data, Error>(error: error)
            .eraseToAnyPublisher()
        
        let expectation = expectation(description: "test_endpointProvider_mappingError")
        var receivedCompletion: Subscribers.Completion<Error>?
        
        // when
        provider.execute(endpoint: .createEndpoint())
            .sink { completion in
                receivedCompletion = completion
                expectation.fulfill()
            } receiveValue: { (result: TestModel) in
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 0.5)
        
        // then
        guard case .failure = receivedCompletion else {
            XCTFail()
            return
        }
    }
    
    func test_executeWithResult_void() {
        // given
        let request: URLRequest = .stub()
        let endpoint = EndpointMock.createEndpoint()
        requestBuilder.buildRequestPublisherMock = Just(request)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        networkProvider.sendPublisher = Just("json".data(using: .utf8)!)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let expectation = expectation(description: "test_endpointProvider_void")
        
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
    
    func test_executeVoid_networkError() {
        test_executeVoid_networkError(.emptyResponse(error: ErrorMock.mock))
        test_executeVoid_networkError(.badResponse(response: .stub()))
        test_executeVoid_networkError(.badRequest(response: .stub()))
        test_executeVoid_networkError(.serverError(response: .stub()))
        test_executeVoid_networkError(.badStatusCode(response: .stub()))
    }
    
    func test_executeVoid_networkError(_ error: NetworkError) {
        // given
        requestBuilder.buildRequestPublisherMock = Just(.stub())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        networkProvider.sendPublisher = Fail<Data, Error>(error: error)
            .eraseToAnyPublisher()
        
        let expectation = expectation(description: "test_endpointProvider_mappingError")
        var receivedCompletion: Subscribers.Completion<Error>?
        
        // when
        provider.execute(endpoint: .createEndpoint())
            .sink { completion in
                receivedCompletion = completion
                expectation.fulfill()
            } receiveValue: { _ in
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 0.5)
        
        // then
        guard case .failure = receivedCompletion else {
            XCTFail()
            return
        }
    }
}
