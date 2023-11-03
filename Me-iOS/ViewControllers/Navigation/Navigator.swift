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
            tabBarController.modalPresentationStyle = .fullScreen
            navController.present(tabBarController, animated: true)
            
        case .transaction:
            let viewControllerr = MTransactionsViewController()
            viewControllerr.hidesBottomBarWhenPushed = true
            navController.show(viewControllerr, sender: nil)
            
        case .productVoucher(let address):
            let productVC = ProductVoucherViewController(navigator: self)
            productVC.address = address
            productVC.hidesBottomBarWhenPushed = true
            navController.show(productVC, sender: nil)
            
        case .budgetVoucher(let voucher):
            let voucherVC = MVoucherViewController(voucher: voucher, navigator: self)
            voucherVC.hidesBottomBarWhenPushed = true
            navController.show(voucherVC, sender: nil)
            
        case .openQRVoucher(let voucher, vc: let vc):
            let popOverVC = PullUpQRViewController(nib: R.nib.pullUpQRViewController)
            popOverVC.voucher = voucher
            popOverVC.qrType = .voucher
            vc.showPopUPWithAnimation(vc: popOverVC)
            
        case .openQRRecord(let record, vc: let vc):
            let popOverVC = PullUpQRViewController(nib: R.nib.pullUpQRViewController)
            popOverVC.record = record
            popOverVC.qrType = .record
            vc.showPopUPWithAnimation(vc: popOverVC)
            
        case .subsidie(let voucher):
            let actionsVC = TransactionManager.shared.actionsScreen(voucher: voucher)
            actionsVC.modalPresentationStyle = .fullScreen
            self.navController.present(actionsVC, animated: true)
            
        case .paymentActions(let paymentAction):
            let paymentVC = MPaymentActionViewController(navigator: self, paymentAction: paymentAction)
            paymentVC.modalPresentationStyle = .fullScreen
            self.navController.present(paymentVC, animated: true)
            
        case .productReservation(let voucherTokens, let voucher):
            let productReservationVC = TransactionManager.shared.productReservationScreen(voucherTokens: voucherTokens, voucher: voucher)
            productReservationVC.modalPresentationStyle = .fullScreen
            
            self.navController.present(productReservationVC, animated: true)
            
        case .paymentContinue(let voucher):
            let paymentVC = MPaymentViewController(navigator: self, voucher: voucher)
            let prevVc = navController.topViewController
            self.navController.show(paymentVC, sender: nil)
            navController.viewControllers.removeAll(where: { $0 == prevVc })
            
        case .payment(let voucher):
            let paymentVC = TransactionManager.shared.paymentScreen(voucher: voucher)
            paymentVC.modalPresentationStyle = .fullScreen
            self.navController.present(paymentVC, animated: true)
            
        case .record:
            let recordVC = MRecordsViewController(navigator: self)
            self.navController.show(recordVC, sender: nil)
            
        case .recordDetail(let record):
            let recordDetailVC = MRecordDetailViewController(navigator: self, record: record)
            self.navController.show(recordDetailVC, sender: nil)
            
        case .qrModal(let voucher, let qrType, let record): break
//            let pullUpQRVC = PullUpQRViewController(voucher: voucher, qrType: qrType, record: record)
//            self.navController.showPopUPWithAnimation(vc: pullUpQRVC)
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
        case openQRVoucher(_ voucher: Voucher, vc: UIViewController)
        case openQRRecord(_ record: Record, vc: UIViewController)
        case subsidie(_ voucher: Voucher)
        case paymentActions(_ paymentAction: PaymenyActionModel)
        case productReservation(_ voucherTokens: [Transaction], _ voucher: Voucher)
        case paymentContinue(_ voucher: Voucher)
        case payment(_ voucher: Voucher)
        case record
        case recordDetail(_ record: Record)
        case qrModal(_ voucher: Voucher? = nil, _ qrType: QRType, _ record: Record? = nil)
    }
}
