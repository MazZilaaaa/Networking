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
        let endpoint = EndpointMock()
        requestBuilder.buildRequestPublisherMock = Just(request)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let result: (data: Data, response: URLResponse) = (data: "{\"title\": \"title\"}".data(using: .utf8)!, response: .stub())
        networkProvider.sendPublisher = Just(result)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        var receivedResult: TestModel?
        
        // when
        provider.load(endpoint: endpoint)
            .sink { _ in
            } receiveValue: { result in
                receivedResult = result
            }
            .store(in: &subscriptions)
        
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
        let endpoint = EndpointMock()
        requestBuilder.buildRequestPublisherMock = Just(request)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let result: (data: Data, response: URLResponse) = (data: Data(), response: .stub())
        networkProvider.sendPublisher = Just(result)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        // when
        provider.load(endpoint: endpoint)
            .sink { _ in
            } receiveValue: { (result: Data) in
            }
            .store(in: &subscriptions)
        
        // then
        XCTAssertEqual(networkProvider.receivedRequest, request)
        XCTAssertEqual(requestBuilder.receivedEndpoint.path, endpoint.path)
        XCTAssertEqual(requestBuilder.receivedEndpoint.method, endpoint.method)
        XCTAssertEqual(requestBuilder.receivedEndpoint.headers, endpoint.headers)
    }
    
    // MARK: Mocking
    
    func test_loadSuccessMockDecodable() {
        // given
        provider.mockEnabled = true
        let data = "{\"title\":\"title\"}".data(using: .utf8)!
        
        // when
        var receviedModel: TestModel?
        provider.load(endpoint: EndpointMock(mockedData: .success(data)))
            .sink { _ in
            } receiveValue: { (result: TestModel) in
                receviedModel = result
            }
            .store(in: &subscriptions)
        
        // then
        XCTAssertEqual(receviedModel?.title, "title")
    }
    
    func test_loadErrorMockDecodable() {
        // given
        provider.mockEnabled = true
        
        // when
        var receivedCompletion: Subscribers.Completion<Error>?
        provider.load(endpoint: EndpointMock(mockedData: .failure(ErrorMock.mock)))
            .sink { completion in
                receivedCompletion = completion
            } receiveValue: { (result: TestModel) in
            }
            .store(in: &subscriptions)
        
        // then
        guard case .failure = receivedCompletion else {
            XCTFail()
            return
        }
    }
    
    // MARK: NetworkError
    
    func test_loadDecodable_networkError() {
        // given
        requestBuilder.buildRequestPublisherMock = Just(.stub())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        networkProvider.sendPublisher = Fail<(data: Data, response: URLResponse), Error>(error: NetworkError.connectionError(reason: ErrorMock.mock))
            .eraseToAnyPublisher()
        
        
        // when
        var receivedCompletion: Subscribers.Completion<Error>?
        provider.load(endpoint: EndpointMock())
            .sink { completion in
                receivedCompletion = completion
            } receiveValue: { (result: TestModel) in
            }
            .store(in: &subscriptions)
        
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
        
        
        // when
        var receivedCompletion: Subscribers.Completion<Error>?
        provider.load(endpoint: EndpointMock())
            .sink { completion in
                receivedCompletion = completion
            } receiveValue: { (result: Data) in
            }
            .store(in: &subscriptions)
        
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
        
        // when
        var receivedCompletion: Subscribers.Completion<Error>?
        provider.load(endpoint: EndpointMock())
            .sink { completion in
                receivedCompletion = completion
            } receiveValue: { (result: TestModel) in
            }
            .store(in: &subscriptions)
        
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
        
        // when
        var receivedCompletion: Subscribers.Completion<Error>?
        provider.load(endpoint: EndpointMock())
            .sink { completion in
                receivedCompletion = completion
            } receiveValue: { (result: TestModel) in
            }
            .store(in: &subscriptions)
        
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
        
        // when
        var receivedCompletion: Subscribers.Completion<Error>?
        provider.load(endpoint: EndpointMock())
            .sink { completion in
                receivedCompletion = completion
            } receiveValue: { (data: Data) in
            }
            .store(in: &subscriptions)
        
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
        
        // when
        var receivedCompletion: Subscribers.Completion<Error>?
        provider.load(endpoint: EndpointMock(errorValidationType: ErrorValidationType.none))
            .sink { completion in
                receivedCompletion = completion
            } receiveValue: { (data: Data) in
            }
            .store(in: &subscriptions)
        
        // then
        guard case .finished = receivedCompletion else {
            XCTFail()
            return
        }
    }
}
