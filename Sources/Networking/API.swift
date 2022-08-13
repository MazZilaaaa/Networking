//
//  API.swift
//  
//
//  Created by Aleksandr Fadeev on 13.08.2022.
//

import Foundation

protocol API {
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [HttpHeader: String]? { get }
}

extension API {
    var headers: [HttpHeader: String]? {
        return nil
    }
}
