//
//  PayFirstApiCall.swift
//  gradual
//
//  Created by Admin on 5/14/20.
//  Copyright © 2020 everydev. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PayFirstRequestHandler: RequestableHandler {
    var baseUrl: String = Constant.BASE_URL
    
    var url: URL {
        return URL(string: self.baseUrl + "donation/pay-first")!
    }
    
    var method: MethodType = .post
    
    var parameters: PayFirstRequest
    
    var encoder: ParameterEncoderType = .json
    
    var headers: [String : String]?
    
    typealias Request = PayFirstRequest
    
}

struct PayResponseHandler: ResponsibleHandler {
    var queue: DispatchQueue = .main
    
    var success: (PayResponse) -> Void
    
    var failure: () -> Void
    
    func getResponse(_ value: Any) -> PayResponse {
        let json = JSON(value)
        
        let status = json["status"].stringValue
        let error = json["error"].stringValue
        let requiresAction = json["requires_action"].boolValue
        let paymentIntentID = json["payment_intent_id"].stringValue
        let clientSecret = json["client_secret"].stringValue
        let customerID = json["customer_id"].stringValue
        
        return PayResponse(status: status, error: error, requiresAction: requiresAction, paymentIntentID: paymentIntentID, clientSecret: clientSecret, customerID: customerID)
    }
    
    typealias Response = PayResponse
}

struct PayFirstApiCall: ApiCallable {
    var requestHandler: PayFirstRequestHandler
    
    var responseHandler: PayResponseHandler
    
    typealias RequestHandler = PayFirstRequestHandler
    
    typealias ResponseHandler = PayResponseHandler
    
    init(parameters: PayFirstRequest, success: @escaping (PayResponse) -> Void, failure: @escaping () -> Void) {
        requestHandler = PayFirstRequestHandler(parameters: parameters)
        responseHandler = PayResponseHandler(success: success, failure: failure)
    }
}
