//
//  File.swift
//  
//
//  Created by Aleksandr Fadeev on 13.08.2022.
//

import Foundation

@testable import Networking

final class MockAPI: API {
    var path: String = ""
    var method: HttpMethod = .get
    var headers: [HttpHeader: String]? = nil
    var queryItems: [URLQueryItem]? = nil
    var body: Data? = nil
    var sampleData: Data? = nil
    
    static func makePostAPI() -> MockAPI {
        let mockAPI = MockAPI()
        mockAPI.path = "/relative/path"
        mockAPI.method = .post
        mockAPI.body = "body".data(using: .utf8)
        
        mockAPI.headers = [
            .accept: "Application/json",
            .authorization: "Bearer token"
        ]
        
        mockAPI.queryItems = [
            URLQueryItem(name: "name1", value: "value1"),
            URLQueryItem(name: "name2", value: "value2")
        ]
        
        return mockAPI
    }
}
