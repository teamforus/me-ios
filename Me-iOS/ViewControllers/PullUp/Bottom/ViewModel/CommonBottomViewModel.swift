//
//  CommonBottomViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/13/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

class CommonBottomViewModel{
    
    var commonService: CommonServiceProtocol!
    var statusService: StatusServiceProtocol!
    
    var completeToken: ((String)->())!
    var completeVoucher: ((String)->())!
    var completeRecord: ((String)->())!
    var completeAuthorize: ((String)->())!
    
    init(commonService: CommonServiceProtocol = CommonService(), statusService: StatusServiceProtocol = StatusService()) {
        self.commonService = commonService
        self.statusService = statusService
    }
    
    func initFetchQrToken(){
        
        self.commonService.post(request: "identity/proxy/token") { (response: AuthorizationQRToken, statusCode) in
            self.completeToken(response.auth_token ?? "")
        }
        
    }
    
    func initFetchVoucherToken(){
        
       
    }
    
    func initFetchRecordToken(idRecords: String){
        
    }
    
    func initAuthorizeToken(token: String){
        statusService.checkStatus(request: token, complete: { [weak self] (response, statusCOde) in
            
            self?.completeAuthorize(response.message ?? "")
            
        }) { (error) in
            
        }
    }
    
}
