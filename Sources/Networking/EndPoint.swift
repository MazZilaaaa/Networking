//
//  EndPoint.swift
//  
//
//  Created by Aleksandr Fadeev on 13.08.2022.
//

public protocol EndPoint {
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [HttpHeader: String]? { get }
}
