//
//  EndpointMock.swift
//  
//
//  Created by Aleksandr Fadeev on 13.08.2022.
//

import Foundation

@testable import Networking

struct EndpointMock: EndPoint {
    var path: String = "/relative"
    var method: HttpMethod = .get()
    var headers: [HttpHeader: String]? = nil
    var errorValidationType: ErrorValidationType? = nil
    var mockedData: Result<Data, Error> = .success(Data())
}
