//
//  AuthorizationQRToken.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/13/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

struct AuthorizationQRToken: Decodable {
    
    var access_token: String?
    var auth_token: String?
    var message: String?
}
