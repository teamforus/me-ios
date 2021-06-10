//
//  MAWaletVoucherTableViewCell.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 8/3/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class VoucherTableViewCell: UITableViewCell {
    var bodyView: CustomCornerUIView = {
        let view = CustomCornerUIView(frame: .zero)
        view.cornerRadius = 12
        view.shadowOpacity = 0.1
        view.shadowRadius = 10
        view.colorName = "Gray_Dark_DarkTheme"
        view.shadowOffset = CGSize(width: 0, height: 0)
        return view
    }()
    
    var voucherTitleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansBold(size: 20)
        return label
    }()
    
    var organizationNameLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansRegular(size: 14)
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = R.font.googleSansRegular(size: 20)
        label.textColor = Color.blueText
        return label
    }()
    
    var voucherImage: RoundImageView = {
        let imageView = RoundImageView(frame: .zero)
        return imageView
    }()
    
    var usedVoucherLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = Color.usedColor
        label.font = R.font.googleSansRegular(size: 15)
        return label
    }()
    
    
    static let identifier = "VoucherTableViewCell"
    
    // MAKR: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
        self.usedVoucherLabel.isHidden = true
        setupIcon()
        self.selectionStyle = .none
        if #available(iOS 11.0, *) {
            self.bodyView.layer.shadowColor = UIColor(named: "Black_Light_DarkTheme")?.cgColor
        } else {}
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  override func prepareForReuse() {
    super.prepareForReuse()
    self.usedVoucherLabel.isHidden = true
  }
    
    func setupVoucher(voucher: Voucher) {
        self.voucherTitleLabel.text = voucher.product != nil ? voucher.product?.name : voucher.fund?.name
        self.organizationNameLabel.text = voucher.product != nil ? voucher.product?.organization?.name  : voucher.fund?.organization?.name
        
        if voucher.expire_at?.date?.formatDate() ?? Date() < Date() {
            self.usedVoucherLabel.isHidden = false
            self.usedVoucherLabel.textColor = .red
            self.usedVoucherLabel.text = Localize.expired()
        }
        
        if voucher.product != nil{
            
            self.priceLabel.isHidden = true
            
            self.voucherImage.loadImageUsingUrlString(urlString: voucher.product?.photo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
        }else{
            self.priceLabel.isHidden = voucher.fund?.type == FundType.subsidies.rawValue
            
            if let price = voucher.amount {
                //                    if voucher?.fund?.currency == "eur" {
                self.priceLabel.text = "€ \(price.substringLeftPart()),\(price.substringRightPart())"
                //                    }else {
                //                        self.priceLabel.attributedText = "ETH \(price.substringLeftPart()).{\(price.substringRightPart())}".customText(fontBigSize: 20, minFontSize: 14)
                //                    }
            }else {
                self.priceLabel.text = "0,0"
            }
            
            self.voucherImage.loadImageUsingUrlString(urlString: voucher.fund?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
        }
    }
    
    func setupSubsidie(subsidie: Subsidie) {
        self.voucherTitleLabel.text = subsidie.name ?? ""
        self.organizationNameLabel.isHidden = true
        self.priceLabel.text = subsidie.price_user ?? ""
        self.voucherImage.loadImageUsingUrlString(urlString:subsidie.photo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 11.0, *) {
            self.bodyView.layer.shadowColor = UIColor(named: "Black_Light_DarkTheme")?.cgColor
        } else {}
    }
    
    func setupIcon() {
        self.voucherImage.layer.masksToBounds = false
        self.voucherImage.clipsToBounds = true
        self.voucherImage.layer.cornerRadius = 13.0
        self.voucherImage.layer.borderColor = #colorLiteral(red: 0.9646214843, green: 0.9647600055, blue: 0.9645912051, alpha: 1)
        self.voucherImage.layer.borderWidth = 1
    }
}

extension VoucherTableViewCell {
    // MARK: - Add Subviews
    private func addSubviews() {
        self.contentView.addSubview(bodyView)
        let views = [voucherTitleLabel, organizationNameLabel, priceLabel, voucherImage, usedVoucherLabel]
        views.forEach { view in
            bodyView.addSubview(view)
        }
    }
}

extension VoucherTableViewCell {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        bodyView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
            make.bottom.equalTo(contentView).offset(-6)
        }
        
        voucherTitleLabel.snp.makeConstraints { make in
            make.left.top.equalTo(bodyView).offset(20)
        }
        
        organizationNameLabel.snp.makeConstraints { make in
            make.top.equalTo(voucherTitleLabel.snp.bottom).offset(2)
            make.left.equalTo(bodyView).offset(20)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(bodyView).offset(20)
            make.top.greaterThanOrEqualTo(organizationNameLabel.snp.bottom).offset(2)
            make.bottom.greaterThanOrEqualTo(bodyView).offset(-20)
        }
        
        voucherImage.snp.makeConstraints { make in
            make.top.equalTo(bodyView).offset(20)
            make.right.equalTo(bodyView).offset(-20)
            make.left.equalTo(voucherTitleLabel.snp.right).offset(10)
            make.height.width.equalTo(50)
        }
        
        usedVoucherLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(voucherImage.snp.bottom).offset(2)
            make.bottom.greaterThanOrEqualTo(bodyView).offset(-20)
            make.right.equalTo(bodyView).offset(-20)
        }
    }
}

extension VoucherTableViewCell {
  func setupAccessibility(with voucherName: String, and voucherOrganization: String) {
    self.bodyView.setupAccesibility(description: Localize.record() + voucherName + voucherOrganization, accessibilityTraits: .button)
  }
}
