//
//  TransactionListTableViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 16.09.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class TransactionListTableViewCell: UITableViewCell {
    
    static let identifier = "TransactionListTableViewCell"
    
    // MARK: - Properties
    private let bodyView: CustomCornerUIView = {
        let view = CustomCornerUIView(frame: .zero)
        view.shadowOffset = CGSize(width: 0, height: 0)
        view.shadowRadius = 10
        view.shadowOpacity = 0.1
        view.colorName = "Gray_Dark_DarkTheme"
        view.cornerRadius = 8
        return view
    }()
    
    private let organizationIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.corner = 12
        return imageView
    }()
    
    private let organizationNameLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Regular", size: 18)
        return label
    }()
    
    private let transactionDateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Regular", size: 13)
        label.textColor = #colorLiteral(red: 0.5150660276, green: 0.5296565294, blue: 0.5467811227, alpha: 1)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Medium", size: 18)
        label.textAlignment = .right
        label.textColor = #colorLiteral(red: 0.1863445938, green: 0.365368098, blue: 0.9889068007, alpha: 1)
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Regular", size: 13)
        label.textColor = #colorLiteral(red: 0.5150660276, green: 0.5296565294, blue: 0.5467811227, alpha: 1)
        label.textAlignment = .right
        return label
    }()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        addSubiews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubiews()
        setupConstraints()
    }
    
    func configure(transaction: Transaction) {
        switch transaction.state {
        case "pending":
            self.statusLabel.text = Localize.pending()
        case "success":
            self.statusLabel.text = Localize.success()
        default:
            self.statusLabel.text = ""
        }
        
        self.organizationNameLabel.text = transaction.product != nil ? transaction.product?.name : transaction.organization?.name ?? ""
        
        if transaction.product != nil {
            
            self.organizationIcon.loadImageUsingUrlString(urlString: transaction.product?.photo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
            
        }else if transaction.organization != nil {
            
            self.organizationIcon.loadImageUsingUrlString(urlString: transaction.organization?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
        }
        
        if let price = transaction.amount {
            if price.double == 0.0 {
                self.priceLabel.text = Localize.free()
            }else {
                self.priceLabel.text = "+ € \(price)"
            }
        }else {
            self.priceLabel.text = "+ € 0"
        }
        self.transactionDateLabel.text = transaction.created_at?.dateFormaterHourDate()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        organizationIcon.image = nil
        organizationNameLabel.text = nil
        transactionDateLabel.text = nil
        priceLabel.text = nil
        statusLabel.text = nil
    }
}


// MARK: - Add Subviews
extension TransactionListTableViewCell {
    private func addSubiews() {
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(bodyView)
        let views = [organizationIcon, organizationNameLabel, transactionDateLabel, priceLabel, statusLabel]
        views.forEach { (view) in
            self.bodyView.addSubview(view)
        }
    }
}

// MARK: - Setup Constraints
extension TransactionListTableViewCell {
    private func setupConstraints() {
        
        bodyView.snp.makeConstraints { make in
            make.left.top.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.bottom.equalTo(self.contentView)
        }
        
        organizationIcon.snp.makeConstraints { make in
            make.centerY.equalTo(bodyView)
            make.left.equalTo(bodyView).offset(15)
            make.height.width.equalTo(24)
        }
        
        organizationNameLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyView).offset(19)
            make.left.equalTo(organizationIcon.snp.right).offset(16)
        }
        
        transactionDateLabel.snp.makeConstraints { make in
            make.top.equalTo(organizationNameLabel.snp.bottom).offset(2)
            make.left.equalTo(organizationIcon.snp.right).offset(16)
            make.bottom.equalTo(bodyView).offset(-17)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.right.equalTo(bodyView).offset(-21)
            make.top.equalTo(bodyView).offset(19)
            make.left.equalTo(organizationNameLabel.snp.right).offset(20)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(2)
            make.right.equalTo(bodyView).offset(-21)
            make.bottom.equalTo(bodyView).offset(-17)
            
        }
    }
}
