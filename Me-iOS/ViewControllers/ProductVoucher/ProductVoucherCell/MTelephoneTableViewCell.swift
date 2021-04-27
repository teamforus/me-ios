//
//  MTelephoneTableViewCell.swift
//  Me-iOS
//
//  Created by mac on 02.02.2021.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MTelephoneTableViewCell: UITableViewCell {
    static let identifier = "MTelephoneTableViewCell"
    var voucher: Voucher!
    
    private let bodyView: Background_DarkMode = {
        let bodyView = Background_DarkMode(frame: .zero)
        bodyView.colorName = "DarkGray_DarkTheme"
        return bodyView
    }()
    
    private let titleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.text = Localize.telephone()
        label.textColor = #colorLiteral(red: 0.396032095, green: 0.3961050212, blue: 0.3960274756, alpha: 1)
        label.font = R.font.googleSansRegular(size: 14)
        return label
    }()
    
    private let infoTitleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansRegular(size: 16)
        return label
    }()
    
    private let iconImage: UIImageView = {
        let imageQRCodeVoucher = UIImageView(frame: .zero)
        imageQRCodeVoucher.image = UIImage(named: "phoneIcon")
        imageQRCodeVoucher.contentMode = .scaleAspectFit
        return imageQRCodeVoucher
    }()
    
    private let separatorView: UIView = {
        let bodyView = UIView(frame: .zero)
        bodyView.backgroundColor = .white
        bodyView.backgroundColor = #colorLiteral(red: 0.8427287936, green: 0.8550025821, blue: 0.8549366593, alpha: 1)
        return bodyView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubviews()
        self.setupConstraints()
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupVoucher(voucher: Voucher?) {
        self.infoTitleLabel.text = voucher?.offices?.first?.phone ?? ""
        
    }
    
}

extension MTelephoneTableViewCell {
    func addSubviews() {
        let views = [bodyView, titleLabel, infoTitleLabel, separatorView, iconImage]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(view)
        }
    }
    func setupConstraints(){
        NSLayoutConstraint.activate([
            bodyView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            bodyView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            bodyView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant:  -10),
            bodyView.heightAnchor.constraint(equalToConstant: 70),
            bodyView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0)
        ])
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.bodyView.topAnchor, constant: 9),
            titleLabel.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor, constant: 16),
        ])
        
        
        NSLayoutConstraint.activate([
            infoTitleLabel.topAnchor.constraint(equalTo: self.bodyView.topAnchor, constant: 35),
            infoTitleLabel.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor, constant: 16),
        ])
        
        
        NSLayoutConstraint.activate([
            separatorView.trailingAnchor.constraint(equalTo: self.bodyView.trailingAnchor, constant: -15),
            separatorView.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor, constant: 15),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.bottomAnchor.constraint(equalTo: self.bodyView.bottomAnchor,constant: -2)
        ])
        
        NSLayoutConstraint.activate([
            iconImage.topAnchor.constraint(equalTo: self.bodyView.topAnchor, constant: 16),
            iconImage.trailingAnchor.constraint(equalTo: self.bodyView.trailingAnchor, constant: -15),
            iconImage.heightAnchor.constraint(equalToConstant: 40),
            iconImage.widthAnchor.constraint(equalToConstant: 40),
        ])
        
    }
}
