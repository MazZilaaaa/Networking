//
//  URLRequestBuilderTests.swift
//  
//
//  Created by Aleksandr Fadeev on 13.08.2022.
//

import XCTest

@testable import Networking

final class URLRequestBuilderTests: XCTestCase {
    
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
    
    func test_buildRequest() throws {
        // given
        let hostUrl = URL(string: "https://github.com")!
        let builder = URLRequestBuilder(hostUrl: hostUrl)
        let postAPI = MockAPI.makePostAPI()
        
        // when
        let request = try builder.buildRequest(postAPI)
        
        // then
        XCTAssertEqual(request.url?.scheme, hostUrl.scheme)
        XCTAssertEqual(request.url?.host, hostUrl.host)
        XCTAssertEqual(request.url?.relativePath, postAPI.path)
        XCTAssertEqual(request.httpMethod, postAPI.method.rawValue)
        XCTAssertEqual(request.httpBody, postAPI.body)
        
        postAPI.headers?.forEach { header in
            XCTAssertEqual(request.allHTTPHeaderFields?[header.key.rawValue], header.value)
        }
        
        postAPI.queryItems?.forEach { queryItem in
            XCTAssertTrue(request.url?.query?.contains("\(queryItem)") == true)
        }
    }
}
