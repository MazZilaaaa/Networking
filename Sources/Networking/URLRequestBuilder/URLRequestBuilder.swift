//
//  File.swift
//  
//
//  Created by Aleksandr Fadeev on 13.08.2022.
//

import Foundation

enum URLRequestBuilderError: Error {
    case baseUrlBuilding
    case requestBuilding(description: String)
}

final class URLRequestBuilder {
    let hostUrl: URL
    
    init(hostUrl: URL) {
        self.hostUrl = hostUrl
    }
    
    init(hostString: String) throws {
        guard let host = URL(string: hostString) else {
            throw URLRequestBuilderError.baseUrlBuilding
        }
        
        self.hostUrl = host
    }
    
    func buildRequest(_ api: API) throws -> URLRequest {
        var urlComponents = URLComponents(url: hostUrl, resolvingAgainstBaseURL: false)
        urlComponents?.path = api.path
        urlComponents?.queryItems = api.queryItems
        
        guard let url = urlComponents?.url else {
            throw URLRequestBuilderError.requestBuilding(description: "check \(api.self) path or queryItems")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = api.method.rawValue
        
        api.headers?.forEach { header in
            request.addValue(header.value, forHTTPHeaderField: header.key.rawValue)
        }
        
        if api.method == .post {
            request.httpBody = api.body
        }
        
        return request
    }
}
