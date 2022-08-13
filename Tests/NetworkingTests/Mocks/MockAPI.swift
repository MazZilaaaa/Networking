//
//  File.swift
//  
//
//  Created by Aleksandr Fadeev on 13.08.2022.
//

import Foundation
@testable import Networking

final class MockAPI: API {
    var path: String = ""
    var method: HttpMethod = .get
    var headers: [HttpHeader: String]? = nil
    var queryItems: [URLQueryItem]? = nil
    var body: Data? = nil
    var sampleData: Data? = nil
}
