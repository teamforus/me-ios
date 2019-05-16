//
//  Logo.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/16/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation


struct Logo: Decodable {
    
    var uid: String?
    var originalName: String?
    var type: String?
    var ext: String?
    var sizes: Size?
}

struct Size: Decodable {
    
    var thumbnail: String?
    var large: String?
}
