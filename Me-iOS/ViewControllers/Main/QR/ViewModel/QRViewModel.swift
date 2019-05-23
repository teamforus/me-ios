//
//  QRViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation


class QRViewModel{
    
    var commonService: CommonServiceProtocol!
    var authorizeToken: (()->())!
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    
    func initAuthorizeToken(token: String) {
        let parameters = ["auth_token" : token]
        
        commonService.postWithParameters(request: "identity/proxy/authorize/token", parameters: parameters, complete: { (response: AuthorizationQRToken, statusCode) in
            self.authorizeToken?()
        }) { (error) in
            
        }
        
    }
    
    
    func initVoucherAddress(address: String) {
    }
    
    
    func initValidationRecord(code: String) {
        
    }
}
