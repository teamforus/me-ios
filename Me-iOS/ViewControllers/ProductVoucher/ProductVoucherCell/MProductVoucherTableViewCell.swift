//
//  MProductVoucherTableViewCell.swift
//  Me-iOS
//
//  Created by mac on 01.02.2021.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MProductVoucherTableViewCell: UITableViewCell {
    
    static let identifier = "MProductVoucherTableViewCell"
    
    var voucher: Voucher!
    private let imageVoucher: UIImageView = {
        let imageVoucher = UIImageView(frame: .zero)
        imageVoucher.image = UIImage(named: "voucher_ticket_icon")
        return imageVoucher
    }()
    
    private let productName: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansMedium(size: 20)
        return label
    }()
    
    private var organizationName: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansRegular(size: 13)
        return label
    }()
    
    private let imageQRCodeVoucher: UIImageView = {
        let imageQRCodeVoucher = UIImageView(frame: .zero)
        imageQRCodeVoucher.contentMode = .scaleAspectFit
        return imageQRCodeVoucher
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupProduct(voucher: Voucher?) {
        self.productName.text = voucher?.product?.name
        self.imageQRCodeVoucher.generateQRCode(from: "{\"type\": \"voucher\",\"value\": \"\(voucher?.address ?? "")\" }")
        self.organizationName.text = voucher?.product?.organization?.name
    }
    
    func setup(voucher: Voucher?) {
        guard let voucher = voucher else { return }
        if voucher.deactivated == false {
            self.imageQRCodeVoucher.generateQRCode(from: "{\"type\": \"voucher\",\"value\": \"\(voucher.address ?? "")\" }")
        }
        self.productName.text = voucher.fund?.name
        self.organizationName.text = voucher.fund?.organization?.name
        
        if voucher.fund?.type == FundType.subsidies.rawValue {
            self.priceLabel.isHidden = true
        }else if !(voucher.amount_visible ?? false){
            self.priceLabel.isHidden = true
        }
      
        self.priceLabel.text = "€ \(voucher.amount ?? String.empty)"
    }
}

extension MProductVoucherTableViewCell {
    // MARK: - Add Subviews
    private func addSubviews() {
        let views = [imageVoucher, productName, organizationName, imageQRCodeVoucher, priceLabel]
        views.forEach { (view) in
            self.contentView.addSubview(view)
        }
    }
}

extension MProductVoucherTableViewCell {
    // MARK: - Setup Constraints
    private func setupConstraints(){
        
        imageVoucher.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView).offset(15)
            make.right.equalTo(contentView).offset(-15)
            make.bottom.equalTo(contentView).offset(-10)
        }
        
        productName.snp.makeConstraints { make in
            make.top.left.equalTo(imageVoucher).offset(20)
            make.width.equalTo(180)
        }
        
        organizationName.snp.makeConstraints { make in
            make.top.equalTo(productName.snp.bottom).offset(5)
            make.left.equalTo(imageVoucher).offset(20)
            make.width.equalTo(180)
        }
        
        imageQRCodeVoucher.snp.makeConstraints { make in
            make.right.equalTo(imageVoucher).offset(-10)
            make.centerY.equalTo(imageVoucher)
            make.height.width.equalTo(76)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(imageVoucher).offset(20)
            make.top.equalTo(organizationName.snp.bottom).offset(3)
        }
    }
}


