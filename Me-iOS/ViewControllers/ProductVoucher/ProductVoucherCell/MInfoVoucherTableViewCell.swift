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
            self.contentView.addSubview(view)
        }
    }
}

extension MInfoVoucherTableViewCell {
    // MARK: - Setup Constraints
    private func setupConstraints(){
        
        bodyView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(contentView)
        }
        
        emailButton.snp.makeConstraints { make in
            make.left.equalTo(bodyView).offset(20)
            make.centerY.equalTo(bodyView)
            make.height.equalTo(46)
            make.width.equalTo(170)
        }
        
        voucherInfoButton.snp.makeConstraints { make in
            make.right.equalTo(bodyView).offset(-17)
            make.left.equalTo(emailButton.snp.right).offset(12)
            make.height.equalTo(46)
            make.centerY.equalTo(emailButton)
        }
        
        iconImageButton.snp.makeConstraints { make in
            make.top.left.equalTo(emailButton).offset(12)
            make.height.equalTo(20)
            make.width.equalTo(23)
        }
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
