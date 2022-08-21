//
//  EndPoint.swift
//  
//
//  Created by Aleksandr Fadeev on 13.08.2022.
//

import Foundation

public enum ErrorValidationType {
    case none
    case badRequests
}

public protocol EndPoint {
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [HttpHeader: String]? { get }
    var errorValidationType: ErrorValidationType? { get }
    var mockedData: Result<Data, Error> { get }
}

public extension EndPoint {
    var headers: [HttpHeader: String]? {
        return nil
    }
    
    var errorValidationType: ErrorValidationType? {
        return .badRequests
    }
    
    var mockedData: Result<Data, Error> {
        return Result<Data, Error>.success(Data())
    }
}
