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
        bodyView.colorName = "Gray_Dark_DarkTheme"
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
            self.contentView.addSubview(view)
        }
    }
    func setupConstraints(){
        
        bodyView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(contentView).offset(-10)
            make.left.equalTo(contentView).offset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyView).offset(9)
            make.left.equalTo(bodyView).offset(16)
        }
        
        infoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyView).offset(35)
            make.left.equalTo(bodyView).offset(16)
        }
        
        separatorView.snp.makeConstraints { make in
            make.right.equalTo(bodyView).offset(-15)
            make.left.equalTo(bodyView).offset(15)
            make.height.equalTo(1)
            make.bottom.equalTo(bodyView).offset(-2)
        }
        
        iconImage.snp.makeConstraints { make in
            make.top.equalTo(bodyView).offset(16)
            make.right.equalTo(bodyView).offset(-15)
            make.height.width.equalTo(40)
        }
    }
}
