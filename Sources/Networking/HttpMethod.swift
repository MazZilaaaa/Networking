//
//  File.swift
//  
//
//  Created by Aleksandr Fadeev on 13.08.2022.
//

import Foundation

///// [Request methods specification](https://datatracker.ietf.org/doc/html/rfc7231#section-4)
enum HttpMethod {
    case get(queryItems: [URLQueryItem]? = nil)
    case head(queryItems: [URLQueryItem]? = nil)
    case post(body: Data? = nil)
    case put(body: Data? = nil)
    case delete(queryItems: [URLQueryItem]? = nil)
    case connect
    case options
    case trace
    case patch
}

extension HttpMethod {
    var rawValue: String {
        switch self {
        case .get:
            return "GET"
        case .head:
            return "HEAD"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        case .connect:
            return "CONNECT"
        case .options:
            return "OPTIONS"
        case .trace:
            return "TRACE"
        case .patch:
            return "PATCH"
        }
    }
}
