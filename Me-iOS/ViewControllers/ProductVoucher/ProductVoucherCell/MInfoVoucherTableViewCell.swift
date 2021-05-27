//
//  MInfoVoucherTableViewCell.swift
//  Me-iOS
//
//  Created by mac on 04.02.2021.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MInfoVoucherTableViewCell: UITableViewCell {
    static let identifier = "MInfoVoucherTableViewCell"
    var emailCompletion: (()->())?
    var infoCompletion: (()->())?
    
    private let bodyView: Background_DarkMode = {
        let bodyView = Background_DarkMode(frame: .zero)
        bodyView.colorName = "WhiteBackground_DarkTheme"
        return bodyView
    }()
    
    private let emailButton: DarkMode_ActionButton = {
        let button = DarkMode_ActionButton(frame: .zero)
        button.backgroundColor = #colorLiteral(red: 0.9449954033, green: 0.9451572299, blue: 0.9449852109, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 0.1918309331, green: 0.3696506619, blue: 0.9919955134, alpha: 1), for: .normal)
        button.titleLabel?.font = R.font.googleSansRegular(size: 14)
        button.setTitle(Localize.email_to_me(), for: .normal)
        button.rounded(cornerRadius: 6)
        button.colorNameTitle = "Blue_DarkTheme"
        button.colorName = "VoucherButton"
        return button
    }()
    
    private let voucherInfoButton: DarkMode_ActionButton = {
        let button = DarkMode_ActionButton(frame: .zero)
        button.backgroundColor = #colorLiteral(red: 0.9449954033, green: 0.9451572299, blue: 0.9449852109, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 0.1918309331, green: 0.3696506619, blue: 0.9919955134, alpha: 1), for: .normal)
        button.titleLabel?.font = R.font.googleSansRegular(size: 14)
        button.setTitle(Localize.voucher_info(), for: .normal)
        button.colorNameTitle = "Blue_DarkTheme"
        button.colorName = "VoucherButton"
        button.rounded(cornerRadius: 6)
        return button
    }()
    
    private let iconImageButton: UIImageView = {
        let imageQRCodeVoucher = UIImageView(frame: .zero)
        imageQRCodeVoucher.image = UIImage(named: "email1")
        imageQRCodeVoucher.contentMode = .scaleAspectFit
        return imageQRCodeVoucher
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
        setupUI()
    }
    
    private func setupUI() {
        setupActions()
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension MInfoVoucherTableViewCell {
    // MARK: - Add Subviews
    private func addSubviews() {
        let views = [bodyView, emailButton, iconImageButton, voucherInfoButton]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(view)
        }
    }
}

extension MInfoVoucherTableViewCell {
    // MARK: - Setup Constraints
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            bodyView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            bodyView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            bodyView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant:  0),
            bodyView.heightAnchor.constraint(equalToConstant: 70),
            bodyView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            emailButton.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor, constant: 20),
            emailButton.centerYAnchor.constraint(equalTo: self.bodyView.centerYAnchor),
            emailButton.heightAnchor.constraint(equalToConstant: 46),
            emailButton.widthAnchor.constraint(equalToConstant: 170),
        ])
        
        NSLayoutConstraint.activate([
            voucherInfoButton.trailingAnchor.constraint(equalTo: self.bodyView.trailingAnchor, constant:  -17),
            voucherInfoButton.leadingAnchor.constraint(equalTo: self.emailButton.trailingAnchor, constant: 12),
            voucherInfoButton.heightAnchor.constraint(equalToConstant: 46),
            voucherInfoButton.centerYAnchor.constraint(equalTo: emailButton.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            iconImageButton.topAnchor.constraint(equalTo: self.emailButton.topAnchor, constant: 12),
            iconImageButton.leadingAnchor.constraint(equalTo: self.emailButton.leadingAnchor, constant: 12),
            iconImageButton.heightAnchor.constraint(equalToConstant: 20),
            iconImageButton.widthAnchor.constraint(equalToConstant: 23),
        ])
    }
}

extension MInfoVoucherTableViewCell {
    // MARK: - Setup Actions
    private func setupActions() {
        emailButton.actionHandleBlock = { [weak self] (_) in
            self?.emailCompletion?()
        }
        
        voucherInfoButton.actionHandleBlock = { [weak self] (_) in
            self?.infoCompletion?()
        }
    }
}
