//
//  ProductReservationDataSource.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 25.05.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

class ProductReservationDataSource: NSObject {
    var voucherTokens: [Transaction]
    
    init(voucherTokens: [Transaction]) {
        self.voucherTokens = voucherTokens
        super.init()
    }
}

extension ProductReservationDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voucherTokens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductReservationTableViewCell.identifier, for: indexPath) as? ProductReservationTableViewCell else {
            return UITableViewCell()
        }
        let voucherToken = voucherTokens[indexPath.row]
        
        cell.setup(voucherToken)
        
        return cell
    }
}
