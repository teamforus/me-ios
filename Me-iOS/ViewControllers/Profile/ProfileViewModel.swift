//
//  ProfileViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 6/6/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation


class ProfileViewModel {
    
    var commonService: CommonServiceProtocol!
    
    var complete: ((String, String)->())?
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    func initProfile(){
        
        commonService.get(request: "identity/records", complete: { (response: [Record], statusCode) in
            
            let mutableString = NSMutableString()
            var email: String!
            for record in response{
                if record.key == "given_name"{
                    mutableString.append(record.value ?? "")
                }else if record.key == "primary_email" {
                    email = record.value
                }else if record.key == "family_name" {
                    mutableString.append(" \(record.value ?? "")")
                }
            }
            
            self.complete?(mutableString as String, email)
            
        }) { (error) in
            
        }
        
    }
    
}
