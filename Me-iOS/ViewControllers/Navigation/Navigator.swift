//
//  Navigator.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 14.06.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

class Navigator: NSObject {

    var navController: MeNavigationController!
    
    override init() {
        super.init()
    }
    
    func configure(_ navController: MeNavigationController) {
        self.navController = navController
    }
    
    func navigate(to destination: Destination) {
        switch destination {
        case .successEmail(let email):
            let emailVC = MSuccessEmailViewController(email: email, navigator: self)
            navController.show(emailVC, sender: nil)
            
        case .successRegister:
            let registerVC = MSuccessRegisterViewController(navigator: self)
            navController.show(registerVC, sender: nil)
            
        case .enablePersonalInfo:
            let enableInfoVC = EnablePersonalInformationViewController(navigator: self)
            navController.show(enableInfoVC, sender: nil)
            
        case .home:
            let tabBarController = HomeTabViewController()
            navController.present(tabBarController, animated: true)
            
        case .transaction:
            let viewControllerr = MTransactionsViewController()
            navController.show(viewControllerr, sender: nil)
            
        case .productVoucher(let address):
            let productVC = ProductVoucherViewController()
            productVC.address = address
            navController.show(productVC, sender: nil)
            
        case .budgetVoucher(let voucher):
            let voucherVC = MVoucherViewController(voucher: voucher, navigator: self)
            navController.show(voucherVC, sender: nil)
        }
    }
    
    
    enum Destination {
        case successEmail(_ email: String)
        case successRegister
        case enablePersonalInfo
        case home
        case transaction
        case productVoucher(_ address: String)
        case budgetVoucher(_ voucher: Voucher)
    }
}
