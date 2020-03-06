//
//  CommonBottomViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/13/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import KVSpinnerView

class CommonBottomViewModel{
    
    var commonService: CommonServiceProtocol!
    var statusService: StatusServiceProtocol!
    var vc: UIViewController!
    
    var completeToken: ((String, String)->())!
    var completeVoucher: ((String)->())!
    var completeRecord: ((RecordValidation)->())!
    var completeAuthorize: ((String)->())!
    var completeIdentity: ((String)->())!
    
    init(commonService: CommonServiceProtocol = CommonService(), statusService: StatusServiceProtocol = StatusService()) {
        self.commonService = commonService
        self.statusService = statusService
    }
    
    func initFetchQrToken(){
        
        self.commonService.post(request: "identity/proxy/token") { (response: AuthorizationQRToken, statusCode) in
            
            self.completeToken(response.auth_token ?? "", response.access_token ?? "")
        }
    }
    
    func initFetchVoucherToken(){
        
        
    }
    
    func initFetchRecordToken(idRecords: Int){
        
        let parameters = ["record_id" : idRecords]
        
        self.commonService.postWithParameters(request: "identity/record-validations", parameters: parameters, complete: { (response: RecordValidation, statusCode) in
            if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: "Expired session".localized(), message: "Your session has expired. You are being logged out.".localized() , okAction: UIAlertAction(title: "Log out".localized(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            } else {
                self.completeRecord?(response)
            }
        }) { (error) in
            
        }
    }
    
    func initAuthorizeToken(token: String){
        self.statusService.checkStatus(request: token, complete: {  (response, statusCOde) in
            
            self.completeAuthorize?(response.message ?? "")
            
        }) { (error) in
            
        }
    }
    
    func getIndentity(){
        commonService.get(request: "identity", complete: { (response: Office, statusCode) in
            if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: "Expired session".localized(), message: "Your session has expired. You are being logged out.".localized() , okAction: UIAlertAction(title: "Log out".localized(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            }else {
                self.completeIdentity?(response.address ?? "")
            }
        }) { (error) in
            
        }
    }
    
}
