//
//  PassTableViewCell.swift
//  TestProject
//
//  Created by Tcacenco Daniel on 5/9/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    @IBOutlet weak var companyTitle: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusTransfer: UILabel!
    @IBOutlet weak var imageTransfer: UIImageView!
    var transaction: Transaction?{
        didSet{
            self.statusTransfer.text = transaction?.product != nil ? "Product voucher".localized() : "Transaction".localized()
            self.companyTitle.text = transaction?.product != nil ? transaction?.product?.name : transaction?.organization?.name ?? ""
        
            if transaction?.product != nil {
//                if transaction?.product.photo != nil {
//                    self.imageTransfer.sd_setImage(with: URL(string: transaction?.product.photo?.sizes?.thumbnail ?? ""), placeholderImage: UIImage(named: "Resting"))
//                }
            }else if transaction?.organization != nil {
//                if transaction?.organization.logo != nil {
//                    self.imageTransfer.sd_setImage(with: URL(string: transaction?.organization.logo?.sizes?.thumbnail ?? ""), placeholderImage: UIImage(named: "Resting"))
//                }
            }
            
            if let price = transaction?.amount {
                self.priceLabel.attributedText = "- \(price.substringLeftPart()).{\(price.substringRightPart())}".customText(fontBigSize: 18, minFontSize: 12)
            }else {
                self.priceLabel.attributedText = "0.{0}".customText(fontBigSize: 18, minFontSize: 12)
            }
            self.dateLabel.text = transaction?.created_at?.dateFormaterNormalDate()
        }
    }
    
    
    @IBOutlet weak var imageEarth: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
