//
//  HttpHeader.swift
//  
//
//  Created by Aleksandr Fadeev on 13.08.2022.
//

import Foundation

/// [Request Header fields specification](https://datatracker.ietf.org/doc/html/rfc7231#section-5)
public enum HttpHeader: String, Hashable {
    
    // MARK: Controls
    /// [RFC 7231 HTTP/1.1 Semantics and Content June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-5.1)
    
    /// [RFC 7234 HTTP/1.1 Caching June 2014](https://datatracker.ietf.org/doc/html/rfc7234#section-5.2)
    case cacheControl = "Cache-Control"
    
    /// [RFC 7231 HTTP/1.1 Semantics and Content  June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-5.1.1)
    case expect = "Expect"
    
    ///[RFC 7230 HTTP/1.1 Message Syntax and Routing June 2014](https://datatracker.ietf.org/doc/html/rfc7230#section-5.4)
    case host = "Host"
    
    ///[RFC 7231 HTTP/1.1 Semantics and Content June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-5.1.2)
    case maxForwards = "Max-Forwards"
    
    /// [RFC 7234 HTTP/1.1 Caching June 2014](https://datatracker.ietf.org/doc/html/rfc7234#section-5.4)
    case pragma = "Pragma"
    
    /// [RFC 7233 HTTP/1.1 Range Requests June 2014](https://datatracker.ietf.org/doc/html/rfc7233#section-3.1)
    case range = "Range"
    
    /// [RFC 7230 HTTP/1.1 Message Syntax and Routing June 2014](https://datatracker.ietf.org/doc/html/rfc7230#section-4.3)
    case te = "TE"
    
    
    
    // MARK: Conditionals
    /// [RFC 7231 HTTP/1.1 Semantics and Content  June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-5.2)
    
    /// [RFC 7232 HTTP/1.1 Conditional Requests June 2014](https://datatracker.ietf.org/doc/html/rfc7232#section-3.1)
    case ifMatch = "If-Match"
    
    /// [RFC 7232 HTTP/1.1 Conditional Requests June 2014](https://datatracker.ietf.org/doc/html/rfc7232#section-3.2)
    case ifNoneMatch = "If-None-Match"
    
    /// [RFC 7232 HTTP/1.1 Conditional Requests June 2014](https://datatracker.ietf.org/doc/html/rfc7232#section-3.3)
    case ifModifiedSince = "If-Modified-Since"
    
    /// [RFC 7232 HTTP/1.1 Conditional Requests June 2014](https://datatracker.ietf.org/doc/html/rfc7232#section-3.4)
    case ifUnmodifiedSince = "If-Unmodified-Since"
    
    /// [RFC 7233 HTTP/1.1 Conditional Requests June 2014](https://datatracker.ietf.org/doc/html/rfc7233#section-3.2)
    case ifRange = "If-Range"
    
    
    
    // MARK: ContentNegotiation
    /// [RFC 7231 HTTP/1.1 Semantics and Content June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-5.3)
    
    /// [RFC 7231 HTTP/1.1 Semantics and Content  June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-5.3.2)
    case accept = "Accept"
    
    /// [RFC 7231 HTTP/1.1 Semantics and Content  June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-5.3.3)
    case acceptCharset = "Accept-Charset"
    
    /// [RFC 7231 HTTP/1.1 Semantics and Content  June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-5.3.4)
    case acceptEncoding = "Accept-Encoding"
    
    /// [RFC 7231 HTTP/1.1 Semantics and Content  June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-5.3.5)
    case acceptLanguage = "Accept-Language"
    
    
    
    // MARK: AuthenticationCredentials
    ///[RFC 7231 HTTP/1.1 Semantics and Content June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-5.4)
    
    ///[RFC 7235 HTTP/1.1 Authentication June 2014](https://datatracker.ietf.org/doc/html/rfc7235#section-4.2)
    case authorization = "Authorization"
    
    ///[RFC 7235 HTTP/1.1 Authentication June 2014](https://datatracker.ietf.org/doc/html/rfc7235#section-4.4)
    case proxyAuthorization = "Proxy-Authorization"
    
    
    
    // MARK: RequestContext
    ///[RFC 7231 HTTP/1.1 Semantics and Content June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-5.5)
    
    ///[RFC 7231 HTTP/1.1 Semantics and Content  June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-5.5.1)
    case from = "From"
    
    ///[RFC 7231 HTTP/1.1 Semantics and Content  June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-5.5.2)
    case referer = "Referer"
    
    ///[RFC 7231 HTTP/1.1 Semantics and Content  June 2014](https://datatracker.ietf.org/doc/html/rfc7231#section-5.5.3)
    case userAgent = "User-Agent"
}
