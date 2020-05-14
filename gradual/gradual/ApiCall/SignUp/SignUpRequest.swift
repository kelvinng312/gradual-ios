//
//  SignUpRequest.swift
//  gradual
//
//  Created by Admin on 5/10/20.
//  Copyright © 2020 everydev. All rights reserved.
//

import Foundation

struct SignUpRequest: Encodable {
    var name: String
    var email: String
    var password: String
    var confrimPassword: String
}
