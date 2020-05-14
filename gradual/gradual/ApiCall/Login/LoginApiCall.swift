//
//  LoginApiCall.swift
//  carcam
//
//  Created by Admin on 5/9/20.
//  Copyright © 2020 PeakBlue. All rights reserved.
//

import Foundation
import SwiftyJSON

struct LoginRequestHandler : RequestableHandler {
    var baseUrl: String = Constant.BASE_URL
    
    var url: URL {
        return URL(string: self.baseUrl + "auth/login")!
    }
    
    var method: MethodType = .post
    
    var parameters: LoginRequest
    
    var encoder: ParameterEncoderType = .json
    
    var headers: [String : String]? = nil
    
    typealias Request = LoginRequest
}

struct LoginResponseHandler: ResponsibleHandler {
    var queue: DispatchQueue = .main
    
    var success: (LoginResponse) -> Void
    var failure: () -> Void
    
    func getResponse(_ value: Any) -> LoginResponse {
        let json = JSON(value)
        
        if let token = json["token"].string {
            let id = json["id"].intValue
            let name = json["name"].stringValue
            let email = json["email"].stringValue
            let publishable_key = json["publishable_key"].stringValue
            let customer_id = json["customer_id"].stringValue
            
            return LoginResponse(id: id, name: name, email: email,
                                 token: token, publishable_key: publishable_key, customer_id: customer_id)
        }
        
        return LoginResponse()
    }
    
    typealias Response = LoginResponse
}

class LoginApiCall: ApiCallable {
    var requestHandler: LoginRequestHandler
    
    var responseHandler: LoginResponseHandler
    
    typealias RequestHandler = LoginRequestHandler
    
    typealias ResponseHandler = LoginResponseHandler
    
    init(parameters: LoginRequest, success: @escaping (LoginResponse) -> Void, failure: @escaping () -> Void) {
        requestHandler = LoginRequestHandler(parameters: parameters)
        responseHandler = LoginResponseHandler(success: success, failure: failure)
    }
}
