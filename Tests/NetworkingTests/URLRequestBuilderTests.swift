//
//  URLRequestBuilderTests.swift
//  
//
//  Created by Aleksandr Fadeev on 13.08.2022.
//

import XCTest

@testable import Networking

final class URLRequestBuilderTests: XCTestCase {
    private var builder: URLRequestBuilder!
    private var hostUrl: URL!
    
    override func setUp() {
        super.setUp()
        
        hostUrl = URL(string: "https://github.com")!
        builder = URLRequestBuilder(hostUrl: hostUrl)
    }
    
    func test_createBuilderWithUrl() {
        // given
        let hostUrl = URL(string: "https://github.com")!
        
        // then
        let builder = URLRequestBuilder(hostUrl: hostUrl)
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
            guard case URLRequestBuilderError.baseUrlBuilding = error else {
                return XCTFail("error should be \(URLRequestBuilderError.baseUrlBuilding)")
            }
        }
    }
    
    func test_buildRequest_common() throws {
        // given
        let api = APIMock.createAPI(
            headers: [
                .accept: "Application/json",
                .authorization: "Bearer token"
            ]
        )
        
        // when
        let request = try builder.buildRequest(api)
        
        // then
        XCTAssertEqual(request.url?.scheme, hostUrl.scheme)
        XCTAssertEqual(request.url?.host, hostUrl.host)
        XCTAssertEqual(request.url?.relativePath, api.path)
        
        api.headers?.forEach { header in
            XCTAssertEqual(request.allHTTPHeaderFields?[header.key.rawValue], header.value)
        }
    }
    
    func test_buildGetRequest() throws {
        // given
        let queryItems = [
            URLQueryItem(name: "name1", value: "value1"),
            URLQueryItem(name: "name2", value: "value2")
        ]
        
        let getAPI = APIMock.createAPI(method: .get(queryItems: queryItems))
        
        // when
        let request = try builder.buildRequest(getAPI)
        
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
        
        let headAPI = APIMock(method: .head(queryItems: queryItems))
        
        // when
        let request = try builder.buildRequest(headAPI)
        
        // then
        XCTAssertEqual(request.httpMethod, "HEAD")
        
        queryItems.forEach { queryItem in
            XCTAssertTrue(request.url?.query?.contains("\(queryItem)") == true)
        }
    }
    
    func test_buildPostRequest() throws {
        // given
        let body = "json".data(using: .utf8)!
        let postAPI = APIMock(method: .post(body: body))
        
        // when
        let request = try builder.buildRequest(postAPI)
        
        // then
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.httpBody, body)
    }
    
    func test_buildPutRequest() throws {
        // given
        let body = "json".data(using: .utf8)!
        let putAPI = APIMock(method: .put(body: body))
        
        // when
        let request = try builder.buildRequest(putAPI)
        
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
        
        let deleteAPI = APIMock(method: .delete(queryItems: queryItems))
        
        // when
        let request = try builder.buildRequest(deleteAPI)
        
        // then
        XCTAssertEqual(request.httpMethod, "DELETE")
        
        queryItems.forEach { queryItem in
            XCTAssertTrue(request.url?.query?.contains("\(queryItem)") == true)
        }
    }
}
