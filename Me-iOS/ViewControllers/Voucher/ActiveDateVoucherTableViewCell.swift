//
//  ActiveDateVoucherTableViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 17.06.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

class ActiveDateVoucherTableViewCell: UITableViewCell {
    static let identifier = "ActiveDateVoucherTableViewCell"
    
    // MARK: - Parameters
    
    private let nameLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.text = Localize.history()
        return label
    }()
    
    private let activateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = Localize.activated()
        return label
    }()
    
    private let dateLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        return label
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
    
    func setup(_ voucher: Voucher) {
        dateLabel.text = voucher.expire_at?.date
    }
}

extension ActiveDateVoucherTableViewCell {
    // MARK: - Add Subviews
    private func addSubviews() {
        let views = [nameLabel, activateLabel, dateLabel]
        
        views.forEach { view in
            self.contentView.addSubview(view)
        }
    }
}

extension ActiveDateVoucherTableViewCell {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(16)
            make.centerY.equalTo(contentView)
        }
        
        activateLabel.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-16)
            make.top.equalTo(contentView).offset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-16)
            make.top.equalTo(activateLabel.snp.bottom).offset(3)
        }
    }
}
