//
//  Extension+Data.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/31/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation


extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
