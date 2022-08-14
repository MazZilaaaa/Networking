//
//  HTTPURLResponse+.swift
//  
//
//  Created by Aleksandr Fadeev on 14.08.2022.
//

import Foundation

extension HTTPURLResponse {
    static func stub(
        url: URL = .stub(),
        statusCode: Int =  200,
        httpVersion: String = "1.1",
        headerFields: [String: String]? = nil
    ) -> HTTPURLResponse {
        return HTTPURLResponse(
            url: .stub(),
            statusCode: statusCode,
            httpVersion: httpVersion,
            headerFields: headerFields
        )!
    }
}
