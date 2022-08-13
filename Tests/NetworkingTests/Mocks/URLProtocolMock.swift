//
//  URLProtocolMock.swift
//
//
//  Created by Aleksandr Fadeev on 14.08.2022.
//

import Foundation

final class URLProtocolMock: URLProtocol {
    static var receivedCanonicalRequest: URLRequest?
    static var statusCode: Int?
    static var error: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        URLProtocolMock.receivedCanonicalRequest = request
        
        return request
    }
    
    
    override func startLoading() {
        if let statusCode = URLProtocolMock.statusCode {
            complete(statusCode: statusCode)
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
    
    func complete(statusCode: Int) {
        let response = HTTPURLResponse(url: URL(string: "https://mock.com")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        client?.urlProtocol(self, didLoad: "testData".data(using: .utf8)!)
        client?.urlProtocolDidFinishLoading(self)
    }
}
