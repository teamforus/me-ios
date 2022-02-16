//
//  Voucher.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/16/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

struct Voucher: Decodable {
    
    var found_id: Int?
    var id: Int?
    var identity_address: String?
    var address: String?
    var amount: String?
    var fund: Fund?
    var transactions: [Transaction]?
    var allowed_organizations: [AllowedOrganization]?
    var allowed_product_organizations: [AllowedOrganization]?
    var allowed_product_categories: [AllowedCategory]?
    var allowed_products: [AllowedProduct]?
    var product: Product?
    var product_vouchers: [Transaction]?
    var offices: [Office]?
    var created_at_locale: String?
    var created_at: String?
//    var expire_at: String!
    var expire_at: ExpireAt?
    var deactivated: Bool?
    
}


struct ExpireAt: Decodable {
    var date: String?
    var timeZone: String?
}

struct DeactivatedAt: Decodable {
    var date: String?
    var timeZone: String?
}
