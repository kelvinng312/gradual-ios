//
//  PayConfirmRequest.swift
//  gradual
//
//  Created by Admin on 5/14/20.
//  Copyright © 2020 everydev. All rights reserved.
//

import Foundation

struct PayConfirmRequest: Encodable {
    var userID: Int
    var paymentIntentID: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case paymentIntentID = "payment_intent_id"
    }
}
