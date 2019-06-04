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
    
    var validateRecord: ((RecordValidation)->())!
    var validateApproveRecord: ((Int)->())!
    
    var getVoucher: ((Voucher, Int)->())!
    
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
        
        commonService.get(request: "platform/vouchers/"+address+"/provider", complete: { (response: ResponseData<Voucher>, statusCode) in
            
            self.getVoucher(response.data!, statusCode)
            
        }) { (error) in
            
        }
        
    }
    
    
    func initValidationRecord(code: String) {
        
        commonService.get(request: "identity/record-validations/" + code, complete: { (response: RecordValidation, statusCode) in
            
            self.validateRecord(response)
            
        }) { (error) in
            
        }
        
    }
    
    func initApproveValidationRecord(code: String) {
        
        commonService.get(request: "identity/record-validations/" + code + "/approve", complete: { (response: AuthorizationQRToken, statusCode) in
            
            self.validateApproveRecord(statusCode)
            
        }) { (error) in
            
        }
    }
}
