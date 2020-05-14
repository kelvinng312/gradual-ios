//
//  LoginResponseHandler.swift
//  carcam
//
//  Created by Admin on 5/9/20.
//  Copyright © 2020 PeakBlue. All rights reserved.
//

import Foundation
import SwiftyJSON

struct LoginResponse {
    var id: Int = -1
    var name: String = ""
    var email: String = ""
    var token: String = ""
    var publishable_key: String = ""
    var customer_id: String = ""
}
