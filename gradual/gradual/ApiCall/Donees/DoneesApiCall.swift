//
//  DoneesApiCall.swift
//  gradual
//
//  Created by Admin on 5/10/20.
//  Copyright © 2020 everydev. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DoneesRequestHandler : RequestableHandler {
    var baseUrl: String = Constant.BASE_URL
    
    var url: URL {
        return URL(string: self.baseUrl + "donees")!
    }
    
    var method: MethodType = .get
    
    var parameters: DoneesRequest
    
    var encoder: ParameterEncoderType = .url
    
    var headers: [String : String]? = nil
    
    typealias Request = DoneesRequest
}

struct DoneesResponseHandler: ResponsibleHandler {
    var queue: DispatchQueue = .main
    
    var success: (DoneesResponse) -> Void
    var failure: () -> Void
    
    func getResponse(_ value: Any) -> DoneesResponse {
        let json = JSON(value)
        
        var donees: [Donee] = []
        for doneeJson in json.arrayValue {
            let id = doneeJson["id"].intValue
            let name = doneeJson["name"].stringValue
            let email = doneeJson["email"].stringValue
            let avatar = doneeJson["avatar"].stringValue
            let pubkey = doneeJson["pubkey"].stringValue
            let donee = Donee(id: id, name: name, email: email, avatar: avatar, pubkey: pubkey)
            donees.append(donee)
        }
        
        return DoneesResponse(donees: donees)
    }
    
    typealias Response = DoneesResponse
}

class DoneesApiCall: ApiCallable {
    var requestHandler: DoneesRequestHandler
    
    var responseHandler: DoneesResponseHandler
    
    typealias RequestHandler = DoneesRequestHandler
    
    typealias ResponseHandler = DoneesResponseHandler
    
    init(parameters: DoneesRequest, success: @escaping (DoneesResponse) -> Void, failure: @escaping () -> Void) {
        requestHandler = DoneesRequestHandler(parameters: parameters)
        responseHandler = DoneesResponseHandler(success: success, failure: failure)
    }
}
