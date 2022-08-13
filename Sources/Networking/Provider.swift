////
////  Provider.swift
////  
////
////  Created by Aleksandr Fadeev on 13.08.2022.
////
//
//import Foundation
//
//import Combine
//import Foundation
//
//class Provider<API: API> {
//    private let networkProvider: NetworkProviderProtocol
//    private let urlRequestBuilder: URLRequestBuilderProtocol
//    
//    init(
//        networkProvider: NetworkProviderProtocol = NetworkProvider(),
//        urlRequestBuilder: URLRequestBuilderProtocol = URLRequestBuilder()
//    ) {
//        self.networkProvider = networkProvider
//        self.urlRequestBuilder = urlRequestBuilder
//    }
//    
//    func fetch<T: Decodable>(_ api: API) -> AnyPublisher<Response<T>, Error> {
//        return fetchData(api)
//            .tryMap { result -> Response<T> in
//                let data = try JSONDecoder.decoder.decode(T.self, from: result.data)
//                return Response(data: data, response: result.response)
//            }
//            .mapError({ error in
//                print(error)
//                return error
//            })
//            .eraseToAnyPublisher()
//    }
//    
//    func fetchData(_ api: API) -> AnyPublisher<Response<Data>, Error> {
//        guard let request = urlRequestBuilder.buildRequest(api) else {
//            return Fail(error: NetworkError.badUrl).eraseToAnyPublisher()
//        }
//        
//        return networkProvider.fetch(from: request)
//    }
//}
