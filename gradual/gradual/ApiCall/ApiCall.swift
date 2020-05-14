//
//  ApiCall.swift
//  carcam
//
//  Created by Admin on 5/8/20.
//  Copyright © 2020 PeakBlue. All rights reserved.
//

import Foundation
import Alamofire

enum MethodType {
    case get
    case post
    
    var value: HTTPMethod {
        switch self {
        case .get:
            return HTTPMethod.get
        case .post:
            return HTTPMethod.post
        }
    }
}

enum ParameterEncoderType {
    case json
    case url
    
    var value: ParameterEncoder {
        switch self {
        case .json:
            return JSONParameterEncoder()
        case .url:
            return URLEncodedFormParameterEncoder()
        }
    }
}

protocol RequestableHandler {
    associatedtype Request: Encodable
    
    var url: URL { get }
    var method: MethodType { get }
    var parameters: Request { get }
    var encoder: ParameterEncoderType { get }
    var headers: [String : String]? { get }
}

protocol ResponsibleHandler {
    associatedtype Response
    
    var queue: DispatchQueue { get }
    var success: (Response) -> Void { get }
    var failure: () -> Void { get }
    
    func getResponse(_ value: Any) -> Response
}

protocol ApiCallable {
    associatedtype RequestHandler: RequestableHandler
    associatedtype ResponseHandler: ResponsibleHandler
    
    var requestHandler: RequestHandler { get }
    var responseHandler: ResponseHandler { get }
}

extension ApiCallable {
    func call() {
        let url = requestHandler.url
        let method = requestHandler.method.value
        let parameters = requestHandler.parameters
        let encoder = requestHandler.encoder.value
        let headers = requestHandler.headers == nil ? nil : HTTPHeaders(requestHandler.headers!)
        AF.request(url, method: method, parameters: parameters, encoder: encoder, headers: headers, interceptor: nil, requestModifier: nil).responseJSON(queue: responseHandler.queue) { resp in
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
