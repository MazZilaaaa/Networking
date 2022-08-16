//
//  URLRequestBuilderTests.swift
//  
//
//  Created by Aleksandr Fadeev on 13.08.2022.
//

import XCTest

@testable import Networking

final class URLRequestBuilderTests: XCTestCase {
    private var builder: URLRequestBuilderProtocol!
    private var hostUrl: URL!
    
    override func setUp() {
        super.setUp()
        
        hostUrl = .stub()
        builder = URLRequestBuilder(hostUrl: hostUrl)
    }
    
    func test_createBuilderWithUrl() {
        // then
        XCTAssertEqual(hostUrl, builder.hostUrl)
    }
    
    func test_createBuilderWithValidString() throws {
        // given
        let hostString = "https://github.com"
        
        // then
        let builder = try URLRequestBuilder(hostString: hostString)
        XCTAssertNotNil(builder.hostUrl)
    }
    
    func test_createBuilderWithUnvalidString() {
        // given
        let hostString = ""
        
        // then
        XCTAssertThrowsError(try URLRequestBuilder(hostString: hostString)) { error in
            guard case BuildingRequestError.invalidHostString = error else {
                return XCTFail("error should be \(BuildingRequestError.invalidHostString)")
            }
        }
    }
    
    func test_buildRequest_common() throws {
        // given
        let relativePath = "/relative/path"
        let endpoint = EndpointMock.createEndpoint(
            path: relativePath,
            headers: [
                .accept: "Application/json",
                .authorization: "Bearer token"
            ]
        )
        
        // when
        let request = try builder.buildRequest(endpoint)
        
        // then
        XCTAssertEqual(request.url?.scheme, hostUrl.scheme)
        XCTAssertEqual(request.url?.host, hostUrl.host)
        XCTAssertEqual(request.url?.relativePath, relativePath)
        
        endpoint.headers?.forEach { header in
            XCTAssertEqual(request.allHTTPHeaderFields?[header.key.rawValue], header.value)
        }
    }
    
    func test_buildGetRequest() throws {
        // given
        let queryItems = [
            URLQueryItem(name: "name1", value: "value1"),
            URLQueryItem(name: "name2", value: "value2")
        ]
        
        let endpoint = EndpointMock.createEndpoint(method: .get(queryItems: queryItems))
        
        // when
        let request = try builder.buildRequest(endpoint)
        
        // then
        XCTAssertEqual(request.httpMethod, "GET")
        
        queryItems.forEach { queryItem in
            XCTAssertTrue(request.url?.query?.contains("\(queryItem)") == true)
        }
    }
    
    func test_buildHeadRequest() throws {
        // given
        let queryItems = [
            URLQueryItem(name: "name1", value: "value1"),
            URLQueryItem(name: "name2", value: "value2")
        ]
        
        let endpoint = EndpointMock(method: .head(queryItems: queryItems))
        
        // when
        let request = try builder.buildRequest(endpoint)
        
        // then
        XCTAssertEqual(request.httpMethod, "HEAD")
        
        queryItems.forEach { queryItem in
            XCTAssertTrue(request.url?.query?.contains("\(queryItem)") == true)
        }
    }
    
    func test_buildPostRequest() throws {
        // given
        let body = "json".data(using: .utf8)!
        let endpoint = EndpointMock(method: .post(body: body))
        
        // when
        let request = try builder.buildRequest(endpoint)
        
        // then
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.httpBody, body)
    }
    
    func test_buildPutRequest() throws {
        // given
        let body = "json".data(using: .utf8)!
        let endpoint = EndpointMock(method: .put(body: body))
        
        // when
        let request = try builder.buildRequest(endpoint)
        
        // then
        XCTAssertEqual(request.httpMethod, "PUT")
        XCTAssertEqual(request.httpBody, body)
    }
    
    func test_buildDeleteRequest() throws {
        // given
        let queryItems = [
            URLQueryItem(name: "name1", value: "value1"),
            URLQueryItem(name: "name2", value: "value2")
        ]
        
        let endpoint = EndpointMock(method: .delete(queryItems: queryItems))
        
        // when
        let request = try builder.buildRequest(endpoint)
        
        // then
        XCTAssertEqual(request.httpMethod, "DELETE")
        
        queryItems.forEach { queryItem in
            XCTAssertTrue(request.url?.query?.contains("\(queryItem)") == true)
        }
    }
}
