//
//  VoucherDataSource.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 17.06.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SafariServices

class VoucherDataSource: NSObject {
    var voucher: Voucher
    var parentViewController: MVoucherViewController
    var navigator: Navigator
    
    init(voucher: Voucher, parentViewController: MVoucherViewController, navigator: Navigator) {
        self.voucher = voucher
        self.parentViewController = parentViewController
        self.navigator = navigator
        super.init()
    }
   
    func showVoucherInfo() {
       if voucher.fund?.url_webshop != nil {
           if let url = URL(string: "\(voucher.fund?.url_webshop ?? "")product/\(voucher.product?.id ?? 0)") {
               let safariVC = SFSafariViewController(url: url)
            self.parentViewController.present(safariVC, animated: true, completion: nil)
           }
       }else {
           if let url = URL(string: "https://kerstpakket.forus.io") {
               let safariVC = SFSafariViewController(url: url)
            self.parentViewController.present(safariVC, animated: true, completion: nil)
           }
       }
   }
   
    func sendVoucherToMail() {
        parentViewController.voucherViewModel.completeSendEmail = { [weak self] (statusCode) in
           DispatchQueue.main.async {
            self?.parentViewController.showPopUPWithAnimation(vc: SuccessSendingViewController(nib: R.nib.successSendingViewController))
           }
       }
        parentViewController.showSimpleAlertWithAction(title: Localize.email_to_me(),
                                 message: Localize.send_an_email_to_the_provider(),
                                 okAction: UIAlertAction(title: Localize.confirm(), style: .default, handler: { (action) in
                                    self.parentViewController.voucherViewModel.sendEmail(address: self.voucher.address ?? "")
                                 }),
                                 cancelAction: UIAlertAction(title: Localize.cancel(), style: .cancel, handler: nil))
   }
   
    func callPhone() {
       if let phone = voucher.offices?.first?.phone {
           guard let number = URL(string: "tel://" + (phone)) else { return }
           UIApplication.shared.open(number)
       }
   }
   
    func copyEmailToClipBoard() {
       UIPasteboard.general.string = self.voucher.offices?.first?.organization?.email
        self.parentViewController.showSimpleToast(message: Localize.copied_to_clipboard())
   }
}

extension VoucherDataSource: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return VoucherTableViewSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = VoucherTableViewSection.allCases[section]
        switch sections {
        case .voucher, .activeDate:
            return 1
        case .infoVoucher:
            if voucher.expire_at?.date == nil {
                return 0
            }
            return voucher.expire_at?.date?.formatDate() ?? Date() >= Date() ? 1 : 0
        case .transactions:
            return voucher.transactions?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rows = VoucherTableViewSection.allCases[indexPath.section]
        switch rows {
        case .voucher:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MProductVoucherTableViewCell.identifier, for: indexPath) as? MProductVoucherTableViewCell else {
                return UITableViewCell()
            }
            cell.setup(voucher: voucher)
            return cell
            
        case .infoVoucher:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MInfoVoucherTableViewCell.identifier, for: indexPath) as? MInfoVoucherTableViewCell else {
                return UITableViewCell()
            }
            cell.emailCompletion = { [weak self] () in
                self?.sendVoucherToMail()
            }
            
            cell.infoCompletion = { [weak self] () in
                self?.showVoucherInfo()
            }
            return cell
            
        case .activeDate:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActiveDateVoucherTableViewCell.identifier, for: indexPath) as? ActiveDateVoucherTableViewCell else {
                return UITableViewCell()
            }
            cell.setup(voucher)
            return cell
            
        case .transactions:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as? TransactionTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(transaction: voucher.transactions?[indexPath.row], isSubsidies: false)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sections = VoucherTableViewSection.allCases[indexPath.section]
        switch sections {
        case .voucher:
            if voucher.expire_at?.date?.formatDate() ?? Date() >= Date() {
                navigator.navigate(to: .openQRVoucher(voucher, vc: parentViewController))
            }
        default: ()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sections = VoucherTableViewSection.allCases[indexPath.section]
        switch sections {
        case .voucher:
            return 120
        case .infoVoucher:
            return 70
        case .activeDate:
            return 70
        case .transactions:
            return 90
        }
    }
}
