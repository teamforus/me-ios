//
//  Validator.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/27/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

struct Validator: Decodable, Hashable {
    
    var identity_address: String?
    var state: String?
    var id: Int?
    var organization: Organization?
}
