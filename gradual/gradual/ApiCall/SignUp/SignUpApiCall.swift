//
//  SignUpApiCall.swift
//  gradual
//
//  Created by Admin on 5/10/20.
//  Copyright © 2020 everydev. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SignUpRequestHandler : RequestableHandler {
    var baseUrl: String = Constant.BASE_URL
    
    var url: URL {
        return URL(string: self.baseUrl + "auth/signup")!
    }
    
    var method: MethodType = .post
    
    var parameters: SignUpRequest
    
    var encoder: ParameterEncoderType = .json
    
    var headers: [String : String]? = nil
    
    typealias Request = SignUpRequest
}

struct SignUpResponseHandler: ResponsibleHandler {
    var queue: DispatchQueue = .main
    
    var success: (SignUpResponse) -> Void
    var failure: () -> Void
    
    func getResponse(_ value: Any) -> SignUpResponse {
        let json = JSON(value)
        
        if let token = json["token"].string {
            let id = json["id"].intValue
            let name = json["name"].stringValue
            let email = json["email"].stringValue
            let publishable_key = json["publishable_key"].stringValue
            let customer_id = json["customer_id"].stringValue
            
            return SignUpResponse(id: id, name: name, email: email,
                                 token: token, publishable_key: publishable_key, customer_id: customer_id)
        }
        
        return SignUpResponse()
    }
    
    typealias Response = SignUpResponse
}

class SignUpApiCall: ApiCallable {
    var requestHandler: SignUpRequestHandler
    
    var responseHandler: SignUpResponseHandler
    
    typealias RequestHandler = SignUpRequestHandler
    
    typealias ResponseHandler = SignUpResponseHandler
    
    init(parameters: SignUpRequest, success: @escaping (SignUpResponse) -> Void, failure: @escaping () -> Void) {
        requestHandler = SignUpRequestHandler(parameters: parameters)
        responseHandler = SignUpResponseHandler(success: success, failure: failure)
    }
}
