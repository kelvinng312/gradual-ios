//
//  PayFirstRequest.swift
//  gradual
//
//  Created by Admin on 5/14/20.
//  Copyright © 2020 everydev. All rights reserved.
//

import Foundation

struct PayFirstRequest: Encodable {
    var userID: Int
    var paymentMethodID: String
    var receiveUserID: Int
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case paymentMethodID = "payment_method_id"
        case receiveUserID = "receive_user_id"
    }
}
