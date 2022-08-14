//
//  URLRequest+.swift
//  
//
//  Created by Aleksandr Fadeev on 14.08.2022.
//

import Foundation

extension URLRequest {
    static func stub(url: URL = .stub()) -> URLRequest {
        URLRequest(url: url)
    }
}
