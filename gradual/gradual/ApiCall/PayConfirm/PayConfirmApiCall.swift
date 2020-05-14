//
//  PayConfirmApiCall.swift
//  gradual
//
//  Created by Admin on 5/14/20.
//  Copyright © 2020 everydev. All rights reserved.
//

import Foundation

struct PayConfirmRequestHandler: RequestableHandler {
    var baseUrl: String = Constant.BASE_URL
    
    var url: URL {
        return URL(string: self.baseUrl + "donation/pay-confirm")!
    }
    
    var method: MethodType = .post
    
    var parameters: PayConfirmRequest
    
    var encoder: ParameterEncoderType = .json
    
    var headers: [String : String]?
    
    typealias Request = PayConfirmRequest
    
}

struct PayConfirmApiCall: ApiCallable {
    var requestHandler: PayConfirmRequestHandler
    
    var responseHandler: PayResponseHandler
    
    typealias RequestHandler = PayConfirmRequestHandler
    
    typealias ResponseHandler = PayResponseHandler
    
    init(parameters: PayConfirmRequest, success: @escaping (PayResponse) -> Void, failure: @escaping () -> Void) {
        requestHandler = PayConfirmRequestHandler(parameters: parameters)
        responseHandler = PayResponseHandler(success: success, failure: failure)
    }
}
