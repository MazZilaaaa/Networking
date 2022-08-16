//
//  ResponseValidatorProtocol.swift
//  
//
//  Created by Aleksandr Fadeev on 16.08.2022.
//

import Combine
import Foundation

protocol ResponseValidatorProtocol {
    func validate(response: URLResponse) throws
}
