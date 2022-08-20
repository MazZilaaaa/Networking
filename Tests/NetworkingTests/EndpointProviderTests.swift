//
//  TestModel+.swift
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
    private var responseValidator: ResponseValidatorProtocolMock!
    
    private var subscriptions: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        
        networkProvider = NetworkProviderProtocolMock()
        requestBuilder = URLRequestBuilderProtocolMock()
        responseValidator = ResponseValidatorProtocolMock()
        provider = EndpointProvider(
            networkProvider: networkProvider,
            requestBuilder: requestBuilder,
            responseValidator: responseValidator
        )
    }
    
    // MARK: success responses
    
    func test_loadDecodable() {
        // given
        let request: URLRequest = .stub()
        let endpoint = EndpointMock.createEndpoint()
        requestBuilder.buildRequestPublisherMock = Just(request)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let result: (data: Data, response: URLResponse) = (data: "{\"title\": \"title\"}".data(using: .utf8)!, response: .stub())
        networkProvider.sendPublisher = Just(result)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let expectation = expectation(description: "test_endpointProvider_result")
        var receivedResult: TestModel?
        
        // when
        provider.load(endpoint: endpoint)
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
    
    func test_loadData() {
        // given
        let request: URLRequest = .stub()
        let endpoint = EndpointMock.createEndpoint()
        requestBuilder.buildRequestPublisherMock = Just(request)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let result: (data: Data, response: URLResponse) = (data: Data(), response: .stub())
        networkProvider.sendPublisher = Just(result)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let expectation = expectation(description: "test_endpointProvider_void")
        
        // when
        provider.load(endpoint: endpoint)
            .sink { _ in
                expectation.fulfill()
            } receiveValue: { (result: Data) in
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 0.5)
        
        // then
        XCTAssertEqual(networkProvider.receivedRequest, request)
        XCTAssertEqual(requestBuilder.receivedEndpoint.path, endpoint.path)
        XCTAssertEqual(requestBuilder.receivedEndpoint.method, endpoint.method)
        XCTAssertEqual(requestBuilder.receivedEndpoint.headers, endpoint.headers)
    }
    
    // MARK: NetworkError
    
    func test_loadDecodable_networkError() {
        // given
        requestBuilder.buildRequestPublisherMock = Just(.stub())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        networkProvider.sendPublisher = Fail<(data: Data, response: URLResponse), Error>(error: NetworkError.connectionError(reason: ErrorMock.mock))
            .eraseToAnyPublisher()
        
        let expectation = expectation(description: "test_endpointProvider_mappingError")
        var receivedCompletion: Subscribers.Completion<Error>?
        
        // when
        provider.load(endpoint: .createEndpoint())
            .sink { completion in
                receivedCompletion = completion
                expectation.fulfill()
            } receiveValue: { (result: TestModel) in
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 0.5)
        
        // then
        guard case let .failure(receivedError) = receivedCompletion else {
            XCTFail()
            return
        }
        
        guard case NetworkError.connectionError = receivedError else {
            XCTFail()
            return
        }
    }
    
    func test_loadData_networkError() {
        // given
        requestBuilder.buildRequestPublisherMock = Just(.stub())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        networkProvider.sendPublisher = Fail<(data: Data, response: URLResponse), Error>(error: NetworkError.connectionError(reason: ErrorMock.mock))
            .eraseToAnyPublisher()
        
        let expectation = expectation(description: "test_endpointProvider_mappingError")
        var receivedCompletion: Subscribers.Completion<Error>?
        
        // when
        provider.load(endpoint: .createEndpoint())
            .sink { completion in
                receivedCompletion = completion
                expectation.fulfill()
            } receiveValue: { (result: Data) in
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 0.5)
        
        // then
        guard case let .failure(receivedError) = receivedCompletion else {
            XCTFail()
            return
        }
        
        guard case NetworkError.connectionError = receivedError else {
            XCTFail()
            return
        }
    }
    
    // MARK: MappingError
    
    func test_loadDecodable_mappingError() {
        // given
        requestBuilder.buildRequestPublisherMock = Just(.stub())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let result: (data: Data, response: URLResponse) = (data: "{\"description\": \"description\"}".data(using: .utf8)!, response: .stub())
        networkProvider.sendPublisher = CurrentValueSubject(result).eraseToAnyPublisher()
        
        let expectation = expectation(description: "test_endpointProvider_mappingError")
        var receivedCompletion: Subscribers.Completion<Error>?
        
        // when
        provider.load(endpoint: .createEndpoint())
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
    
    // MARK: ResponseValidatingError
    
    func test_loadDecodable_validatingResponseError() {
        test_loadDecodable_validateError(.redirect(response: .stub()))
        test_loadDecodable_validateError(.badResponse(response: .stub()))
        test_loadDecodable_validateError(.badRequest(response: .stub()))
        test_loadDecodable_validateError(.serverError(response: .stub()))
        test_loadDecodable_validateError(.badStatusCode(response: .stub()))
    }
    
    func test_loadDecodable_validateError(_ error: ResponseValidatorError) {
        // given
        requestBuilder.buildRequestPublisherMock = CurrentValueSubject(.stub()).eraseToAnyPublisher()
        
        let result: (data: Data, response: URLResponse) = (data: Data(), response: .stub())
        networkProvider.sendPublisher = CurrentValueSubject(result).eraseToAnyPublisher()
        responseValidator.throwError = error
        
        var receivedCompletion: Subscribers.Completion<Error>?
        let expectation = expectation(description: "test_loadWithResult_validateError")
        
        // when
        provider.load(endpoint: .createEndpoint())
            .sink { completion in
                receivedCompletion = completion
                expectation.fulfill()
            } receiveValue: { (result: TestModel) in
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 0.5)
        
        guard case let .failure(receivedError) = receivedCompletion else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(receivedError as? ResponseValidatorError, error)
    }
    
    func test_loadData_validatingResponseError() {
        test_loadData_validatingResponseError(.badResponse(response: .stub()))
        test_loadData_validatingResponseError(.badRequest(response: .stub()))
        test_loadData_validatingResponseError(.serverError(response: .stub()))
        test_loadData_validatingResponseError(.badStatusCode(response: .stub()))
    }
    
    func test_loadData_validatingResponseError(_ error: ResponseValidatorError) {
        // given
        requestBuilder.buildRequestPublisherMock = CurrentValueSubject(.stub()).eraseToAnyPublisher()
        
        let result: (data: Data, response: URLResponse) = (data: Data(), response: .stub())
        networkProvider.sendPublisher = CurrentValueSubject(result).eraseToAnyPublisher()
        responseValidator.throwError = error
        
        let expectation = expectation(description: "test_endpointProvider_mappingError")
        var receivedCompletion: Subscribers.Completion<Error>?
        
        // when
        provider.load(endpoint: .createEndpoint())
            .sink { completion in
                receivedCompletion = completion
                expectation.fulfill()
            } receiveValue: { (data: Data) in
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 0.5)
        
        // then
        guard case let .failure(receivedError) = receivedCompletion else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(receivedError as? ResponseValidatorError, error)
    }
    
    func test_loadData_validatingDisabledResponseError() {
        // given
        requestBuilder.buildRequestPublisherMock = Just(.stub())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let result: (data: Data, response: URLResponse) = (data: Data(), response: .stub())
        networkProvider.sendPublisher = Just(result)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        responseValidator.throwError = ResponseValidatorError.redirect(response: .stub())
        
        let expectation = expectation(description: "test_endpointProvider_mappingError")
        var receivedCompletion: Subscribers.Completion<Error>?
        
        // when
        provider.load(endpoint: .createEndpoint(errorValidationType: ErrorValidationType.none))
            .sink { completion in
                receivedCompletion = completion
                expectation.fulfill()
            } receiveValue: { (data: Data) in
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 0.5)
        
        // then
        guard case .finished = receivedCompletion else {
            XCTFail()
            return
        }
    }
}
