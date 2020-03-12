//
//  SuccessEmailViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/31/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation


class SuccessEmailViewModel {
    
    var commonService: CommonServiceProtocol!
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    var complete: ((String)->())?
    
    func initCheckAuthorize(token: String) {
        
        commonService.getWithoutToken(request: "identity/proxy/authorize/email/exchange/" + token, complete: { (response: AuthorizationQRToken, statusCode) in
            self.complete?(response.access_token ?? "")
        }) { (error) in
            
        }
    }
    
    func initSignUp(token: String) {
        
        commonService.getWithoutToken(request: "identity/proxy/confirmation/exchange/" + token, complete: { (response: AuthorizationQRToken, statusCode) in
            self.complete?(response.access_token ?? "")
        }) { (error) in
            
        }
    }
}
