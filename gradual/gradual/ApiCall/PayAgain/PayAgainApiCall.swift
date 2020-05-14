//
//  PayAgainApiCall.swift
//  gradual
//
//  Created by Admin on 5/14/20.
//  Copyright © 2020 everydev. All rights reserved.
//

import Foundation

struct PayAgainRequestHandler: RequestableHandler {
    var baseUrl: String = Constant.BASE_URL
    
    var url: URL {
        return URL(string: self.baseUrl + "donation/pay-again")!
    }
    
    var method: MethodType = .post
    
    var parameters: PayAgainRequest
    
    var encoder: ParameterEncoderType = .json
    
    var headers: [String : String]?
    
    typealias Request = PayAgainRequest
    
}

struct PayAgainApiCall: ApiCallable {
    var requestHandler: PayAgainRequestHandler
    
    var responseHandler: PayResponseHandler
    
    typealias RequestHandler = PayAgainRequestHandler
    
    typealias ResponseHandler = PayResponseHandler
    
    init(parameters: PayAgainRequest, success: @escaping (PayResponse) -> Void, failure: @escaping () -> Void) {
        requestHandler = PayAgainRequestHandler(parameters: parameters)
        responseHandler = PayResponseHandler(success: success, failure: failure)
    }
}
