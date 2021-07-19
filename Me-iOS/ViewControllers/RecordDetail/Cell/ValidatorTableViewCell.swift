//
//  ValidatorTableViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/27/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class ValidatorTableViewCell: UITableViewCell {
    
    private var iconValidator: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    private var nameValidatorLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansMedium(size: 18)
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = R.font.googleSansRegular(size: 14)
        label.textColor = Color.lightGrayText
        return label
    }()
    
    private var validatorAddressLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = R.font.googleSansRegular(size: 14)
        label.textColor = Color.lightGrayText
        return label
    }()
    
    private var bottomBorrder: CustomCornerUIView = {
        let view = CustomCornerUIView(frame: .zero)
        view.colorName = "Gray_Dark_DarkTheme"
        return view
    }()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
      if #available(iOS 11.0, *) {
        self.contentView.backgroundColor = UIColor(named: "DarkGray_DarkTheme")
      } else {}
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup View
    func setup(_ validator: Validator) {
        self.dateLabel.text = validator.created_at?.dateFormaterNormalDate() ?? String.empty
        self.nameValidatorLabel.text = validator.organization?.name ?? String.empty
        self.validatorAddressLabel.text = validator.identity_address ?? String.empty
    }
}

extension ValidatorTableViewCell {
    // MAKR: Add Subviews
    private func addSubviews() {
        let views = [iconValidator, nameValidatorLabel, dateLabel, validatorAddressLabel]
        
        views.forEach { view in
            self.contentView.addSubview(view)
        }
    }
}

extension ValidatorTableViewCell {
    // MAKR: Setup Constraints
    private func setupConstraints() {
        iconValidator.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.top.equalTo(contentView).offset(22)
            make.left.equalTo(contentView).offset(17)
        }
        
        
    }
}


