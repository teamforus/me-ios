//
//  OrganizationTableViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 29.06.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

class OrganizationPaymentTableViewCell: UITableViewCell {
    static let identifier = "OrganizationPaymentTableViewCell"
    
    // MARK: - Parameters
    private let organizationIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = Image.faceIcon
        imageView.rounded(cornerRadius: 6)
        return imageView
    }()
    
    private let nameLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansRegular(size: 16)
        return label
    }()
    
    private let arrowIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = Image.arrowRightIcon
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let bottomView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    func setup(organization: Organization) {
        nameLabel.text = organization.name ?? ""
        organizationIcon.loadImageUsingUrlString(urlString: organization.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
    }
    
    // MARK: - Setup View
    func setup(organization: AllowedOrganization) {
        nameLabel.text = organization.name ?? ""
        organizationIcon.loadImageUsingUrlString(urlString: organization.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
    }
}

extension OrganizationPaymentTableViewCell {
    // MARK: - Add Subviews
    private func addSubviews() {
        let views = [organizationIcon, nameLabel, arrowIcon, bottomView]
        views.forEach { view in
            self.contentView.addSubview(view)
        }
        
    }
}

extension OrganizationPaymentTableViewCell {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        organizationIcon.snp.makeConstraints { make in
            make.left.equalTo(self.contentView).offset(20)
            make.width.height.equalTo(35)
            make.centerY.equalTo(self.contentView)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(organizationIcon.snp.right).offset(10)
            make.centerY.equalTo(self.contentView)
        }
        
        arrowIcon.snp.makeConstraints { make in
            make.right.equalTo(self.contentView).offset(-20)
            make.centerY.equalTo(self.contentView)
            make.height.width.equalTo(16)
        }
        
        bottomView.snp.makeConstraints { make in
            make.bottom.equalTo(self.contentView).offset(-1)
            make.left.right.equalTo(self.contentView)
            make.height.equalTo(1)
        }
    }
}
