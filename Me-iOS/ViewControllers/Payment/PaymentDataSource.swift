//
//  PaymentDataSource.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 29.06.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

enum PaymentRowType: Int, CaseIterable {
    case voucher = 0
    case organization
    case amount
    case note
}

class PaymentDataSource: NSObject {
    var voucher: Voucher
    
    init(voucher: Voucher) {
        self.voucher = voucher
        super.init()
    }
}

extension PaymentDataSource: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PaymentRowType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = PaymentRowType.allCases[indexPath.row]
        switch row {
        case .voucher:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MProductVoucherTableViewCell.identifier, for: indexPath) as? MProductVoucherTableViewCell else {
                return UITableViewCell()
            }
            cell.setup(voucher: voucher)
            return cell
            
        case .organization:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OrganizationPaymentTableViewCell.identifier, for: indexPath) as? OrganizationPaymentTableViewCell else {
                return UITableViewCell()
            }
            cell.setup(organization: (voucher.allowed_organizations?.first!)!)
            return cell
            
        case .amount:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as? TextFieldTableViewCell else {
                return UITableViewCell()
            }
            cell.setup(placeHolder: Localize.enter_the_price_here())
            return cell
            
        case .note:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as? TextFieldTableViewCell else {
                return UITableViewCell()
            }
            cell.setup(placeHolder: Localize.note())
            return cell
        }
    }
}
