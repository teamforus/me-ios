//
//  ProductCategory.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/16/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

struct ProductCategory: Decodable, Hashable {
    
    var id: Int?
    var key: String?
    var name: String?
    var service: Int?
}
