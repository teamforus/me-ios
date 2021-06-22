//
//  PassTableViewCell.swift
//  TestProject
//
//  Created by Tcacenco Daniel on 5/9/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    static let identifier = "TransactionTableViewCell"
    
    // MARK: - Properties
    var bodyView: Background_DarkMode = {
        var view = Background_DarkMode(frame: .zero)
        view.rounded(cornerRadius: 8)
        view.colorName = "Gray_Dark_DarkTheme"
        return view
    }()
    
    var companyTitle: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansRegular(size: 18)
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = R.font.googleSansRegular(size: 13)
        return label
    }()
    
    var priceLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansMedium(size: 18)
        return label
    }()
    var statusTransfer: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = R.font.googleSansRegular(size: 13)
        return label
    }()
    
    var imageTransfer: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.rounded(cornerRadius: 14)
        return imageView
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(transaction: Transaction?, isSubsidies: Bool) {
        if isSubsidies {
            self.statusTransfer.text = transaction?.created_at?.dateFormaterNormalDate()
        }else {
            self.statusTransfer.text = transaction?.product != nil ? Localize.product_voucher(): Localize.transaction()
        }
        self.companyTitle.text = transaction?.product != nil ? transaction?.product?.name : transaction?.organization?.name ?? ""
        self.priceLabel.isHidden = isSubsidies
        if transaction?.product != nil {
            
            self.imageTransfer.loadImageUsingUrlString(urlString: transaction?.product?.photo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
            
        }else if transaction?.organization != nil {
            
            self.imageTransfer.loadImageUsingUrlString(urlString: transaction?.organization?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
        }
        if let price = transaction?.amount {
            self.priceLabel.text = "€ \(price.substringLeftPart()),\(price.substringRightPart())"
        }else {
            self.priceLabel.text = "€ 0,0"
        }
        self.dateLabel.text = isSubsidies ? transaction?.organization?.name : transaction?.created_at?.dateFormaterNormalDate()
    }
}

extension TransactionTableViewCell {
    // MARK: - Add Subviews
    private func addSubviews() {
        self.contentView.addSubview(bodyView)
        let views = [companyTitle, dateLabel, priceLabel, statusTransfer, imageTransfer]
        views.forEach { view in
            self.bodyView.addSubview(view)
        }
    }
}

extension TransactionTableViewCell {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        bodyView.snp.makeConstraints { make in
            make.top.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-10)
            make.bottom.equalTo(contentView).offset(-1)
        }
        
        imageTransfer.snp.makeConstraints { make in
            make.centerY.equalTo(bodyView)
            make.width.height.equalTo(40)
            make.left.equalTo(bodyView).offset(15)
        }
        
        companyTitle.snp.makeConstraints { make in
            make.left.equalTo(imageTransfer.snp.right).offset(8)
            make.top.equalTo(bodyView).offset(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(companyTitle.snp.bottom).offset(2)
            make.left.equalTo(imageTransfer.snp.right).offset(8)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.right.equalTo(bodyView).offset(-8)
            make.top.equalTo(bodyView).offset(20)
        }
        
        statusTransfer.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(2)
            make.right.equalTo(bodyView).offset(-8)
        }
        
    }
}
