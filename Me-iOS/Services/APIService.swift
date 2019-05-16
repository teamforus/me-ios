//
//  APIService.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/15/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation


class ApiService{
    
    static func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
}
