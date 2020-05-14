//
//  LoginRequest.swift
//  carcam
//
//  Created by Admin on 5/9/20.
//  Copyright © 2020 PeakBlue. All rights reserved.
//

import Foundation

struct LoginRequest: Encodable {
    var email: String
    var password: String
}
