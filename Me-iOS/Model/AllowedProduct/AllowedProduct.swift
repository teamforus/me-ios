//
//  AllowedProduct.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/16/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

struct AllowedProduct: Decodable {
    
    var id: Int?
    var name: String?
    var description: String?
    var price: Int?
    var old_price: Int?
    var total_amount: Int?
    var sold_amount: Int?
}
