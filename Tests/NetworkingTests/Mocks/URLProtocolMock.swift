//
//  URLProtocolMock.swift
//
//
//  Created by Aleksandr Fadeev on 14.08.2022.
//

import Foundation

enum URLPRotocolResponseMock {
    case ok(data: Data? = nil)
    case badRequest(response: URLResponse? = nil)
    case serverError(response: URLResponse? = nil)
    case badStatusCode(response: URLResponse? = nil)
    
    var statusCode: Int {
        switch self {
        case .ok:
            return 200
        case .badRequest:
            return 400
        case .serverError:
            return 500
        case .badStatusCode:
            return 600
        }
    }
}

final class URLProtocolMock: URLProtocol {
    static var receivedCanonicalRequest: URLRequest?
    static var responseMock: URLPRotocolResponseMock?
    static var error: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        URLProtocolMock.receivedCanonicalRequest = request
        
        return request
    }
    
    
    override func startLoading() {
        if let response = URLProtocolMock.responseMock {
            complete(responseMock: response)
            return
        }
        
        if let error = URLProtocolMock.error {
            fail(error: error)
        }
    }
    
    override func stopLoading() {
    }
    
    func fail(error: Error) {
        client?.urlProtocol(self, didFailWithError: error)
    }
    
    func complete(responseMock: URLPRotocolResponseMock) {
        let responseHTTPURLResponse: HTTPURLResponse  = .stub(
            statusCode: responseMock.statusCode
        )
        
        client?.urlProtocol(self, didReceive: responseHTTPURLResponse, cacheStoragePolicy: .allowed)
        
        if case let .ok(data) = responseMock,
            let data = data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
}
