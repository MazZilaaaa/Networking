//
//  NetworkError.swift
//  
//
//  Created by Aleksandr Fadeev on 14.08.2022.
//

import Foundation

enum NetworkError: Error {
    case connectionError(reason: Error)
}
