//
//  EndPoint.swift
//  
//
//  Created by Aleksandr Fadeev on 13.08.2022.
//

import Foundation

public protocol EndPoint {
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [HttpHeader: String]? { get }
}

extension EndPoint {
    var headers: [HttpHeader: String]? {
        return nil
    }
}
