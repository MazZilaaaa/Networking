//
//  BuildingRequestError.swift
//  
//
//  Created by Aleksandr Fadeev on 16.08.2022.
//

import Foundation

enum BuildingRequestError: Error {
    case invalidHostString
    case invalidUrlComponents(description: String)
}
