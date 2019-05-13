//
//  ResponseData.swift
//  Troc
//
//  Created by Tcacenco Daniel on 4/4/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

struct ResponseDataArray<T: Decodable> : Decodable {
    
    var data: [T]?
    var current_page: Int?
    var first_page_url: String?
    var last_page: Int?
    var last_page_url: String?
    var next_page_url: String?
    var path: String?
    var per_page: Int?
    var prev_page_url: String?
    var links: Link?
    var meta: Meta?
    
}

struct Link: Decodable {
    
    var first: String?
    var last: String?
    var prev: String?
    var next: String?
}

struct Meta: Decodable {
    
    var current_page: Int?
    var from: Int?
    var last_page: Int?
    var path: String?
    var per_page: Int?
    var to: Int?
    var total: Int?
}
