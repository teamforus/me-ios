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
            self.statusTransfer.text = transaction?.product != nil ? Localize.product_voucher(): Localize.transaction()
            self.companyTitle.text = transaction?.product != nil ? transaction?.product?.name : transaction?.organization?.name ?? ""
        
            if transaction?.product != nil {
                
                self.imageTransfer.loadImageUsingUrlString(urlString: transaction?.product?.photo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
                
            }else if transaction?.organization != nil {
                
                self.imageTransfer.loadImageUsingUrlString(urlString: transaction?.organization?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
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
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
