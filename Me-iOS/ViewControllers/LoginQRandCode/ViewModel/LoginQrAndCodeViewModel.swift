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
    var statusService: StatusServiceProtocol!
    
    var complete: ((Int, String, Int)->())?
    var completeAuthorize: ((String, Int)->())!
    
    init(commonService: CommonServiceProtocol = CommonService(), statusService: StatusServiceProtocol = StatusService()) {
        self.commonService = commonService
        self.statusService = statusService
    }
    
    
    func initFetchPinCode(){
        
        self.commonService.post(request: "identity/proxy/code") { ( response: PinCode, statusCode) in
            self.complete!(Int(response.exchange_token ?? "0")!, response.access_token ?? "", statusCode)
            
        }
        
    }
    
    func initAuthorizeToken(token: String){
        self.statusService.checkStatus(request: token, complete: { [weak self] (response, statusCode) in
            
            self?.completeAuthorize(response.message ?? "", statusCode)
            
        }) { (error) in
            
        }
    }
    
    
}
