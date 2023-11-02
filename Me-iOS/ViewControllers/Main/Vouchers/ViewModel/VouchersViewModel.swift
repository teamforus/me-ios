//
//  VouchersViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation
import UIKit

class VouchersViewModel{
    
    var commonService: CommonServiceProtocol!
    var selectedVoucher: Voucher?
    var isAllowSegue: Bool = false
    var vc: UIViewController!
    var voucherType: VoucherType!
    
    var completeIdentity: ((Office)->())!
    var completeDeleteToken: ((Int)->())!
    
    private var allVouchers: [Voucher] = [Voucher]()

    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    private var cellViewModels: [Voucher] = [Voucher]() {
        didSet {
            complete?(cellViewModels)
        }
    }
    
    var complete: (([Voucher])->())?
    
    func initFetch(){
        
        commonService.get(request: "platform/vouchers", complete: { (response: ResponseDataArray<Voucher>, statusCode) in
            if statusCode == 503 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showErrorServer()
                }
                
            }else if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: Localize.expired_session(), message: Localize.your_session_has_expired() , okAction: UIAlertAction(title: Localize.log_out(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            } else {
                self.allVouchers = response.data ?? []
                self.complete?(response.data ?? [])
                self.filterVouchers(voucherType: .vouchers)
            }
            
        }, failure: { (error) in
            DispatchQueue.main.async {
                KVSpinnerView.dismiss()
            }
        })
        
    }
    
    func sendPushToken(token: String){
        commonService.postWithoutResponse(request: "platform/devices/register-push", body: BodyId(id: token), complete: { (statusCode) in
            print("Push Notification status code: \(statusCode)")
        }) { (error) in
        }
    }
    
    func deletePushToken(token: String){
        commonService.deleteWithoutResponse(request: "platform/devices/delete-push", body: BodyId(id: token), complete: { (statusCode) in
            print("Push Notification delete status code: \(statusCode)")
            self.completeDeleteToken?(statusCode)
        }) { (error) in
            print(error)
        }
    }
    
    func filterVouchers(voucherType: VoucherType) {
        cellViewModels = allVouchers.filter({voucherType == .vouchers ? $0.expire_at?.date?.formatDate() ?? Date() > Date() 
            || Calendar.current.isDate($0.expire_at?.date?.formatDate() ?? Date(), inSameDayAs:Date()) :
            
            $0.expire_at?.date?.formatDate() ?? Date() < Date() 
            && !Calendar.current.isDate($0.expire_at?.date?.formatDate() ?? Date(), inSameDayAs:Date())})
        
    }
    
    func getIndentity(){
        commonService.get(request: "identity", complete: { (response: Office, statusCode) in
            if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: Localize.expired_session(), message: Localize.your_session_has_expired() , okAction: UIAlertAction(title: Localize.log_out(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            }else {
                self.completeIdentity?(response)
            }
        }) { (error) in
            
        }
    }
}
