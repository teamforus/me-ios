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
    var amount: String!
    var tabBar: UITabBarController!
    var organizationId: Int!
    var note: String!
    var commonService: CommonServiceProtocol! = CommonService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if voucher.product != nil {
            
            paymentLabel.text = "Are you sure you want to confirm this transaction".localized()
            
            self.didChangeHeightView()
            
        }else {
            
            let amountVoucher = Double(voucher.amount ?? "0.00")!
            let aditionalAmount = Double(amount.replacingOccurrences(of: ",", with: "."))! - amountVoucher
            
            paymentLabel.text = String(format: NSLocalizedString("Please confirm the transaction of %@", comment: ""), amount)
            
            
            if Double(amount!.replacingOccurrences(of: ",", with: "."))! > amountVoucher {
                
                insuficientLabel.text = String(format: NSLocalizedString("Insufficient funds on the voucher. Please, request extra payment of €%.02f", comment: ""), aditionalAmount)
                
            }else{
                
                self.didChangeHeightView()
                
            }
        }
    }
    
    
    @IBAction func confirm(_ sender: Any) {
        
        if isReachable() {
            
            KVSpinnerView.show()
            let payTransaction = PayTransaction(organization_id: organizationId ?? 0, amount: amount ?? "", note: note ?? "")
            
            commonService.create(request: "platform/vouchers/"+voucher.address!+"/transactions", data: payTransaction) { (response: ResponseData<Transaction>, statusCode) in
                
                
                if statusCode == 201 {
                    
                    self.showSimpleAlertWithSingleAction(title: "Success".localized(), message: "Payment succeeded".localized(), okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        
                        self.tabBar.selectedIndex = 0
                        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
                    }))
                }else {
                    self.showSimpleAlertWithSingleAction(title: "Warning".localized(), message: "Voucher not have enough funds".localized(), okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        
                        KVSpinnerView.dismiss()
                    }))
                }
                
            }
        }else {
            
            showInternetUnable()
            
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
