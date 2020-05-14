//
//  File.swift
//  gradual
//
//  Created by Admin on 5/14/20.
//  Copyright © 2020 everydev. All rights reserved.
//

import Foundation

struct PayAgainRequest: Encodable {
    var userID: Int
    var customerID: String
    var receivedUserID: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case customerID = "customer_id"
        case receivedUserID = "receive_user_id"
    }
}
