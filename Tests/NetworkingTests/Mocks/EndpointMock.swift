//
//  EndpointMock.swift
//  
//
//  Created by Aleksandr Fadeev on 13.08.2022.
//

import Foundation

@testable import Networking

struct EndpointMock: EndPoint {
    var path: String
    var method: HttpMethod
    var headers: [HttpHeader: String]?
    
    init(
        path: String = "/relative",
        method: HttpMethod = .get(),
        headers: [HttpHeader : String]? = nil
    ) {
        self.path = path
        self.method = method
        self.headers = headers
    }
}

extension EndpointMock {
    static func createEndpoint(
        path: String = "/relative",
        method: HttpMethod = .get(),
        headers: [HttpHeader : String]? = nil
    ) -> EndPoint {
        EndpointMock(path: path, method: method, headers: headers)
    }
}
