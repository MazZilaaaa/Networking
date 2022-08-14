//
//  HttpMethod.swift
//  
//
//  Created by Aleksandr Fadeev on 13.08.2022.
//

import Foundation

///// [Request methods specification](https://datatracker.ietf.org/doc/html/rfc7231#section-4)
public enum HttpMethod: Hashable {
    
    /// [RFC 7231 HTTP/1.1 Semantics and Content June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-4.3.1)
    case get(queryItems: [URLQueryItem]? = nil)
    
    /// [RFC 7231 HTTP/1.1 Semantics and Content June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-4.3.2)
    case head(queryItems: [URLQueryItem]? = nil)
    
    /// [RFC 7231 HTTP/1.1 Semantics and Content June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-4.3.3)
    case post(body: Data? = nil)
    
    /// [RFC 7231 HTTP/1.1 Semantics and Content June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-4.3.4)
    case put(body: Data? = nil)
    
    /// [RFC 7231 HTTP/1.1 Semantics and Content June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-4.3.5)
    case delete(queryItems: [URLQueryItem]? = nil)
    
    /// [RFC 7231 HTTP/1.1 Semantics and Content June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-4.3.6)
    case connect
    
    /// [RFC 7231 HTTP/1.1 Semantics and Content June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-4.3.7)
    case options
    
    /// [RFC 7231 HTTP/1.1 Semantics and Content June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-4.3.8)
    case trace
    
    /// [RFC 7231 HTTP/1.1 Semantics and Content June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-4.3.9)
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
