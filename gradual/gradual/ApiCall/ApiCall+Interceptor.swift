//
//  ApiCall+Interceptor.swift
//  carcam
//
//  Created by Admin on 5/9/20.
//  Copyright © 2020 PeakBlue. All rights reserved.
//

import Foundation
import Alamofire

protocol Interceptable {
    var interceptHandler: (URLRequest) -> URLRequest { get }
}

protocol ApiCallableWithInterceptor: ApiCallable {
    associatedtype Interceptor: Interceptable
    
    var interceptor: Interceptor { get }
}

final class RequestInterceptor: Alamofire.RequestInterceptor {
    private let interceptor: Interceptable
    
    init(interceptor: Interceptable) {
        self.interceptor = interceptor
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        let urlRequest = interceptor.interceptHandler(urlRequest)
        completion(.success(urlRequest))
    }
}

extension ApiCallableWithInterceptor {
    func callWithInterceptor() {
        let url = requestHandler.url
        let method = requestHandler.method.value
        let parameters = requestHandler.parameters
        let encoder = requestHandler.encoder.value
        let headers = requestHandler.headers == nil ? nil : HTTPHeaders(requestHandler.headers!)
        AF.request(url, method: method, parameters: parameters, encoder: encoder, headers: headers, interceptor: RequestInterceptor(interceptor: interceptor), requestModifier: nil).responseJSON(queue: responseHandler.queue) { resp in
            switch resp.result {
            case .success(let value):
                let response = self.responseHandler.getResponse(value)
                self.responseHandler.success(response)
            case .failure(let error):
                print(error)
            }
        }
    }
}
