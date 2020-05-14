//
//  PayAgainResponse.swift
//  gradual
//
//  Created by Admin on 5/14/20.
//  Copyright © 2020 everydev. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PayResponse {
    var status: String
    var error: String
    var requiresAction: Bool
    var paymentIntentID: String
    var clientSecret: String
    var customerID: String
}
