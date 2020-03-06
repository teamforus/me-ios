//
//  ConfirmPaymentPopUp.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 6/4/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import KVSpinnerView

class ConfirmPaymentPopUp: UIViewController {
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var insuficientLabel: UILabel!
    @IBOutlet weak var bodyView: CustomCornerUIView!
    
    
    var voucher: Voucher!
    var voucherToken: Transaction!
    var testToken: String!
    var amount: String!
    var tabBar: UITabBarController!
    var organizationId: Int!
    var note: String!
    var commonService: CommonServiceProtocol! = CommonService()
    var isFromReservation: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if voucher != nil {
            initView()
        }else {
            paymentLabel.text = String(format: NSLocalizedString("Please confirm the transaction of %@", comment: ""), amount)
            self.didChangeHeightView()
        }
    }
    
    private func initView() {
        
        if voucher.product != nil {
            
            paymentLabel.text = String(format: NSLocalizedString("Please confirm the transaction of %@", comment: ""), voucher.product?.price ?? "0.00")
            amount = voucher.product?.price
            self.didChangeHeightView()
            organizationId = voucher.product?.organization?.id
            
        }else {
            
            let amountVoucher = Double(voucher.amount ?? "0.00")!
            let aditionalAmount = Double(amount.replacingOccurrences(of: ",", with: "."))! - amountVoucher
            
            paymentLabel.text = String(format: NSLocalizedString("Please confirm the transaction of %@", comment: ""), amount)
            
            
            if Double(amount!.replacingOccurrences(of: ",", with: "."))! > amountVoucher {
                //                if voucher.fund?.currency == "eur" {
                insuficientLabel.text = String(format: NSLocalizedString("Insufficient funds on the voucher. Please, request extra payment of €%.02f", comment: ""), aditionalAmount)
                //                }else {
                //                insuficientLabel.text = String(format: NSLocalizedString("Insufficient funds on the voucher. Please, request extra payment of ETH%.02f", comment: ""), aditionalAmount)
                //                }
                
            }else{
                
                self.didChangeHeightView()
                
            }
        }
    }
    
    
    @IBAction func confirm(_ sender: UIButton) {
        sender.isEnabled = false
        if isReachable() {
            
            KVSpinnerView.show()
            
            if voucher != nil {
                let payTransaction = PayTransaction(organization_id: organizationId ?? 0, amount: amount.replacingOccurrences(of: ",", with: "."), note: note ?? "")
                
                commonService.create(request: "platform/vouchers/"+voucher.address!+"/transactions", data: payTransaction) { (response: ResponseData<Transaction>, statusCode) in
                    
                    DispatchQueue.main.async {
                        KVSpinnerView.dismiss()
                        if statusCode == 201 {
                            
                            self.showSimpleAlertWithSingleAction(title: "Success".localized(), message: "Payment succeeded".localized(), okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                
                                self.tabBar.selectedIndex = 0
                                if self.isFromReservation != nil {
                                    self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true)
                                }else {
                                    self.presentingViewController?.presentingViewController?.dismiss(animated: true)
                                }
                            }))
                        }else if statusCode == 401 {
                            DispatchQueue.main.async {
                                KVSpinnerView.dismiss()
                                self.showSimpleAlertWithSingleAction(title: "Expired session".localized(), message: "Your session has expired. You are being logged out.".localized() , okAction: UIAlertAction(title: "Log out".localized(), style: .default, handler: { (action) in
                                    self.logoutOptions()
                                }))
                            }
                        }else {
                            sender.isEnabled = true
                            self.showSimpleAlertWithSingleAction(title: "Warning".localized(), message: "Voucher not have enough funds".localized(), okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                
                                
                            }))
                        }
                    }
                }
            }else {
                
                commonService.patchWithoutParam(request: "platform/demo/transactions/" + testToken) { ( statusCode) in
                    DispatchQueue.main.async {
                        if statusCode == 200 {
                            KVSpinnerView.dismiss()
                            self.showSimpleAlertWithSingleAction(title: "Success".localized(), message: "Payment succeeded".localized(), okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                
                                self.tabBar.selectedIndex = 0
                                if self.isFromReservation != nil {
                                    self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true)
                                }else {
                                    self.presentingViewController?.presentingViewController?.dismiss(animated: true)
                                }
                            }))
                        }else if statusCode == 401 {
                            DispatchQueue.main.async {
                                KVSpinnerView.dismiss()
                                self.showSimpleAlertWithSingleAction(title: "Expired session".localized(), message: "Your session has expired. You are being logged out.".localized() , okAction: UIAlertAction(title: "Log out".localized(), style: .default, handler: { (action) in
                                    self.logoutOptions()
                                }))
                            }
                        }else {
                            KVSpinnerView.dismiss()
                            self.showSimpleAlertWithSingleAction(title: "Error!".localized(), message: "This token is not valid!", okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                
                            }))
                        }
                    }
                }
                
            }
        }else {
            sender.isEnabled = true
            showInternetUnable()
            
        }
    }
    
    func dismissModalStack(viewController: UIViewController, animated: Bool) {
        if viewController.presentingViewController != nil {
            var vc = viewController.presentingViewController!
            while (vc.presentingViewController != nil) {
                vc = vc.presentingViewController!;
            }
            vc.dismiss(animated: true)
            
            
        }
    }
    
}

extension ConfirmPaymentPopUp {
    
    func didChangeHeightView(){
        var reactBodyView = bodyView.frame
        reactBodyView.size.height = reactBodyView.size.height - 36
        bodyView.frame = reactBodyView
        insuficientLabel.isHidden = true
    }
    
}
