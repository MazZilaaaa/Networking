//
//  File.swift
//  
//
//  Created by Aleksandr Fadeev on 20.08.2022.
//

import Combine
import Foundation
import Networking

enum TestEndpoint {
    case test
}

extension TestEndpoint: EndPoint {
    var path: String {
        switch self {
        case .test:
            return "/"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .test:
            return .get()
        }
    }
    
    var headers: [HttpHeader : String]? {
        return nil
    }
    
    var errorValidationType: ErrorValidationType? {
        return nil
    }
}

var subscriptions: Set<AnyCancellable> = []
let url: URL = URL(string: "https://google.com")!
let provider = EndpointProvider<TestEndpoint>(hostUrl: url)
let group = DispatchGroup()

group.enter()
DispatchQueue.global().async {
    provider.load(endpoint: .test)
        .sink {
            print($0)
            group.leave()
        } receiveValue: { (value: Data) in
            print(value)
            print(String(data: value, encoding: .utf8))
        }
        .store(in: &subscriptions)
}

group.wait()
