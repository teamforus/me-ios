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
        imageVoucher.image = UIImage(named: "5XVoucherContainerWElevation")
        return imageVoucher
    }()
    
    private let labelVoucher: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = R.font.googleSansMedium(size: 21)
        label.textColor = .black
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
        self.labelVoucher.text = voucher?.product?.name ?? ""
        self.imageQRCodeVoucher.generateQRCode(from: "{\"type\": \"voucher\",\"value\": \"\(voucher?.address ?? "")\" }")
    }
    
    func addSubviews() {
        let views = [imageVoucher, labelVoucher, imageQRCodeVoucher]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(view)
        }
    }
    func setupConstraints(){
        NSLayoutConstraint.activate([
            imageVoucher.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            imageVoucher.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            imageVoucher.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant:  -15),
            imageVoucher.heightAnchor.constraint(equalToConstant: 120),
            imageVoucher.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            labelVoucher.topAnchor.constraint(equalTo: self.imageVoucher.topAnchor, constant: 40),
            labelVoucher.leadingAnchor.constraint(equalTo: self.imageVoucher.leadingAnchor, constant: 34),
            labelVoucher.widthAnchor.constraint(equalToConstant: 180),
            labelVoucher.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -53)
        ])
        
        NSLayoutConstraint.activate([
            imageQRCodeVoucher.topAnchor.constraint(equalTo: self.imageVoucher.topAnchor, constant: 22),
            imageQRCodeVoucher.trailingAnchor.constraint(equalTo: self.imageVoucher.trailingAnchor, constant:  -36),
            imageQRCodeVoucher.centerYAnchor.constraint(equalTo: self.labelVoucher.centerYAnchor),
            imageQRCodeVoucher.heightAnchor.constraint(equalToConstant: 76),
            imageQRCodeVoucher.widthAnchor.constraint(equalToConstant: 76),
        ])
    }
    
}


