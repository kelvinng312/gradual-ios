//
//  AccessTokenInterceptor.swift
//  carcam
//
//  Created by Admin on 5/9/20.
//  Copyright © 2020 PeakBlue. All rights reserved.
//

import Foundation

class AccessTokenInterceptor: Interceptable {
    var interceptHandler: (URLRequest) -> URLRequest = { request in
        return request
    }
}
