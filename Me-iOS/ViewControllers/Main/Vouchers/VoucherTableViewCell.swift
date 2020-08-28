//
//  MAWaletVoucherTableViewCell.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 8/3/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class VoucherTableViewCell: UITableViewCell {
    @IBOutlet weak var voucherTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var voucherImage: RoundImageView!
    @IBOutlet weak var organizationNameLabel: UILabel!
    @IBOutlet weak var usedVoucherLabel: UILabel!
    @IBOutlet weak var bodyView: CustomCornerUIView!
    var voucher: Voucher? {
        didSet{
            self.voucherTitleLabel.text = voucher?.product != nil ? voucher?.product?.name : voucher?.fund?.name
            self.organizationNameLabel.text = voucher?.product != nil ? voucher?.product?.organization?.name  : voucher?.fund?.organization?.name
            
            //            if voucher?.transactions != nil{
            //                
            //                usedVoucherLabel.isHidden = false
            //                
            //            } else {
            //                
            //                self.usedVoucherLabel.isHidden = true
            //                
            //            }
            
            if voucher?.expire_at?.date?.formatDate() ?? Date() < Date() {
                self.usedVoucherLabel.isHidden = false
                self.usedVoucherLabel.textColor = .red
                self.usedVoucherLabel.text = Localize.expired()
            }
            
            if voucher?.product != nil{
                
                self.priceLabel.isHidden = true
                
                self.voucherImage.loadImageUsingUrlString(urlString: voucher?.product?.photo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
            }else{
                self.priceLabel.isHidden = false
                
                if let price = voucher?.amount {
//                    if voucher?.fund?.currency == "eur" {
                        self.priceLabel.text = "€ \(price.substringLeftPart()),\(price.substringRightPart())"
//                    }else {
//                        self.priceLabel.attributedText = "ETH \(price.substringLeftPart()).{\(price.substringRightPart())}".customText(fontBigSize: 20, minFontSize: 14)
//                    }
                }else {
                    self.priceLabel.text = "0,0"
                }
                
                self.voucherImage.loadImageUsingUrlString(urlString: voucher?.fund?.organization?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.usedVoucherLabel.isHidden = true
        setupIcon()
        self.selectionStyle = .none
        if #available(iOS 11.0, *) {
            self.bodyView.layer.shadowColor = UIColor(named: "Black_Light_DarkTheme")?.cgColor
        } else {}
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 11.0, *) {
            self.bodyView.layer.shadowColor = UIColor(named: "Black_Light_DarkTheme")?.cgColor
        } else {}
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupIcon() {
        self.voucherImage.layer.masksToBounds = false
        self.voucherImage.clipsToBounds = true
        self.voucherImage.layer.cornerRadius = 13.0
        self.voucherImage.layer.borderColor = #colorLiteral(red: 0.9646214843, green: 0.9647600055, blue: 0.9645912051, alpha: 1)
        self.voucherImage.layer.borderWidth = 1
    }
    
}
