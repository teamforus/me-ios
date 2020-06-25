//
//  EmailLoginViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/31/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

class EmailLoginViewModel {
    
    var commonService: CommonServiceProtocol!
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    var complete: ((Int)->())?
    
    func initLoginByEmail(email: String) {
        
        let parameters = ["email" : email]
        
        commonService.postWithParametersWithoutToken(request: "identity/proxy/email", parameters: parameters, complete: { (response: AuthorizationQRToken, statusCode) in
            self.complete?(statusCode)
        }) { (error) in
            
        }
        
    }
}
