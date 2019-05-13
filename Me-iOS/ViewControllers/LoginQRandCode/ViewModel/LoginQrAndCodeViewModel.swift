//
//  LoginQrAndCodeViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/6/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

class LoginQrAndCodeViewModel{
    
    var commonService: CommonServiceProtocol!
    
    var complete: ((Int)->())?
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    
    func initFetchPinCode(){
        
        self.commonService.post(request: "identity/proxy/code") { ( response: PinCode, statusCode) in
            self.complete!(response.auth_code ?? 0)
        }
        
    }
    
    
}
