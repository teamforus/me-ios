//
//  QRViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation
import UIKit
import KVSpinnerView

class QRViewModel{
    
    var commonService: CommonServiceProtocol!
    var vc: MQRViewController!
    var authorizeToken: ((Int)->())!
    var vcAlert: UIViewController!
    
    var validateRecord: ((RecordValidation, Int)->())!
    var validateApproveRecord: ((Int)->())!
    var completeTestToken: (()->())?
    
    var completeOrganization: (([EmployeesOrganization]) -> ())?
    
    var getVoucher: ((Voucher, Int)->())!
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    
    func initAuthorizeToken(token: String) {
        let parameters = ["auth_token" : token]
        
        commonService.postWithParameters(request: "identity/proxy/authorize/token", parameters: parameters, complete: { (response: AuthorizationQRToken, statusCode) in
            
            if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: "Expired session".localized(), message: "Your session has expired. You are being logged out.".localized() , okAction: UIAlertAction(title: "Log out".localized(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            }else {
                
                self.authorizeToken?(statusCode)
            }
        }) { (error) in }
        
    }
    
    
    func initVoucherAddress(address: String) {
        
        commonService.get(request: "platform/vouchers/"+address+"/provider", complete: { (response: ResponseData<Voucher>, statusCode) in
            
            if statusCode == 500 {
                
                DispatchQueue.main.async {
                    
                    KVSpinnerView.dismiss()
                    self.vcAlert.showSimpleAlertWithSingleAction(title: "Warning".localized(), message: "This voucher is expired.", okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.vc?.scanWorker.start()
                    }))
                }
                
            }else if statusCode == 403  {
                DispatchQueue.main.async {
                    
                    KVSpinnerView.dismiss()
                    self.vcAlert.showSimpleAlertWithSingleAction(title: "Error!".localized(), message: response.message ?? "", okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.vc?.scanWorker.start()
                    }))
                }
            }else if statusCode == 404 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vcAlert.showSimpleAlertWithSingleAction(title: "Error!".localized(), message: response.message ?? "", okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.vc?.scanWorker.start()
                    }))
                }
                
            }else if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: "Expired session".localized(), message: "Your session has expired. You are being logged out.".localized() , okAction: UIAlertAction(title: "Log out".localized(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            }else {
                self.getVoucher(response.data!, statusCode)
            }
        }) { (error) in
            DispatchQueue.main.async {
                KVSpinnerView.dismiss()
                self.vc.scanWorker.start()
            }
        }
        
    }
    
    
    func initValidationRecord(code: String) {
        
        commonService.get(request: "identity/record-validations/" + code, complete: { (response: RecordValidation, statusCode) in
            if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: "Expired session".localized(), message: "Your session has expired. You are being logged out.".localized() , okAction: UIAlertAction(title: "Log out".localized(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            } else {
                self.validateRecord(response, statusCode)
            }
        }) { (error) in
            
        }
        
    }
    
    func getOrganizations(){
        commonService.get(request: "platform/employees?role=validation", complete: { (response: ResponseDataArray<EmployeesOrganization>, statusCode) in
             if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: "Expired session".localized(), message: "Your session has expired. You are being logged out.".localized() , okAction: UIAlertAction(title: "Log out".localized(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            }else {
                self.completeOrganization?(response.data ?? [])
            }
        }) { (error) in
            
        }
    }
    
    func initApproveValidationRecord(code: String, organization: OrganizationRecord) {
        
        commonService.patch(request: "identity/record-validations/" + code + "/approve", data: organization) { (response: AuthorizationQRToken, statusCode) in
            if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: "Expired session".localized(), message: "Your session has expired. You are being logged out.".localized() , okAction: UIAlertAction(title: "Log out".localized(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            }else {
                self.validateApproveRecord(statusCode)
            }
        }
    }
    
    func initTestTransaction() {
        
        commonService.get(request: "platform/demo/transactions/" +  CurrentSession.shared.token, complete: { (response: ResponseDataArray<EmployeesOrganization>, statusCode) in
            if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: "Expired session".localized(), message: "Your session has expired. You are being logged out.".localized() , okAction: UIAlertAction(title: "Log out".localized(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            }else {
                self.completeTestToken?()
            }
        }) { (error) in
            
        }
    }
}
