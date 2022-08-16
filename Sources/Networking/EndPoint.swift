//
//  EndPoint.swift
//  
//
//  Created by Aleksandr Fadeev on 13.08.2022.
//

public enum ErrorValidationType {
    case none
    case badRequests
}

public protocol EndPoint {
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [HttpHeader: String]? { get }
    var errorValidationType: ErrorValidationType? { get }
}

extension EndPoint {
    var errorValidationType: ErrorValidationType? {
        return .badRequests
    }
}
