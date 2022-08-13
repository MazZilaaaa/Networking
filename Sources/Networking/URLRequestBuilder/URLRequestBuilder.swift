//
//  URLRequestBuilderError.swift
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
        
        switch api.method {
        case let .get(queryItems), let .head(queryItems), let .delete(queryItems):
            urlComponents?.queryItems = queryItems
        default:
            break
        }
        
        guard let url = urlComponents?.url else {
            throw URLRequestBuilderError.requestBuilding(description: "check \(api.self) path or queryItems")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = api.method.rawValue
        
        api.headers?.forEach { header in
            request.addValue(header.value, forHTTPHeaderField: header.key.rawValue)
        }
        
        switch api.method {
        case let .post(body), let .put(body):
            request.httpBody = body
        default:
            break
        }
        
        return request
    }
}
