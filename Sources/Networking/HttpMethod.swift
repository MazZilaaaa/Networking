//
//  File.swift
//  
//
//  Created by Aleksandr Fadeev on 13.08.2022.
//

import Foundation

///// [Request methods specification](https://datatracker.ietf.org/doc/html/rfc7231#section-4)
enum HttpMethod: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case connect = "CONNECT"
    case options = "OPTIONS"
    case trace = "TRACE"
    case PATCH = "PATCH"
}
