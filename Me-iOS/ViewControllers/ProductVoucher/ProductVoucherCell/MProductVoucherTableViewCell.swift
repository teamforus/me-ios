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
        imageQRCodeVoucher.image = UIImage(named: "qrCode")
        imageQRCodeVoucher.contentMode = .scaleAspectFit
        return imageQRCodeVoucher
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
    
    func setupVoucher(voucher: Voucher?) {
        self.productName.text = voucher?.product?.name ?? ""
        self.imageQRCodeVoucher.generateQRCode(from: "{\"type\": \"voucher\",\"value\": \"\(voucher?.address ?? "")\" }")
        self.organizationName.text = voucher?.product?.organization?.name ?? ""
    }
}

extension MProductVoucherTableViewCell {
    // MARK: - Add Subviews
    private func addSubviews() {
        let views = [imageVoucher, productName, organizationName, imageQRCodeVoucher]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(view)
        }
    }
}

extension MProductVoucherTableViewCell {
    // MARK: - Setup Constraints
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            imageVoucher.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            imageVoucher.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            imageVoucher.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant:  -15),
            imageVoucher.heightAnchor.constraint(equalToConstant: 120),
            imageVoucher.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            productName.topAnchor.constraint(equalTo: self.imageVoucher.topAnchor, constant: 20),
            productName.leadingAnchor.constraint(equalTo: self.imageVoucher.leadingAnchor, constant: 20),
            productName.widthAnchor.constraint(equalToConstant: 180)
        ])
        
        NSLayoutConstraint.activate([
            organizationName.topAnchor.constraint(equalTo: self.productName.bottomAnchor, constant: 5),
            organizationName.leadingAnchor.constraint(equalTo: self.imageVoucher.leadingAnchor, constant: 20),
            organizationName.widthAnchor.constraint(equalToConstant: 180)
        ])
        
        NSLayoutConstraint.activate([
            imageQRCodeVoucher.trailingAnchor.constraint(equalTo: self.imageVoucher.trailingAnchor, constant:  -10),
            imageQRCodeVoucher.centerYAnchor.constraint(equalTo: self.imageVoucher.centerYAnchor),
            imageQRCodeVoucher.heightAnchor.constraint(equalToConstant: 76),
            imageQRCodeVoucher.widthAnchor.constraint(equalToConstant: 76),
        ])
    }
}


