//
//  Product.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/16/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

struct Product: Decodable {
    
    var id: Int?
    var name: String?
    var description: String?
    var price: String?
    var old_price: String?
    var total_amount: Int?
    var sold_amounts: Int?
    var organization: Organization?
    var organization_id: Int?
    var product_category_id: Int?
    var photo: Logo?
}
