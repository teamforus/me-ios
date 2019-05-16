//
//  AllowedOrganization.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/16/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

struct AllowedOrganization: Decodable{
    
    var id: Int?
    var name: String?
    var logo: Logo?
}

struct AllowedCategory: Decodable{
    
    var id: Int?
    var name: String?
    var key: String?
}
