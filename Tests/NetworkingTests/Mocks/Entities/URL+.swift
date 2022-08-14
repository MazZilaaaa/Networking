//
//  File.swift
//  
//
//  Created by Aleksandr Fadeev on 14.08.2022.
//

import Foundation

extension URL {
    static func stub(string: String = "https://host.com") -> URL {
        return URL(string: string)!
    }
}
