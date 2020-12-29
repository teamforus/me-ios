//
//  Subsidies.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 03.09.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

struct Subsidie: Decodable {
    var id: Int?
    var name: String?
    var price_user: String?
    var organization_id: Int?
    var photo: Logo?
    var no_price: Bool?
    var price_old: String?
    var price: String?
    var sold_out: Bool?
    var unlimited_stock: Bool?
    var organization: Organization?
    var product_category: ProductCategory?
}
