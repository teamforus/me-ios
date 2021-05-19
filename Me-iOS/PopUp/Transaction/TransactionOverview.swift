//
//  TransactionOverview.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 31.08.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class TransactionOverview: UIView {
    
    private let transpartentView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        return view
    }()
    
    private let bodyView: Background_DarkMode = {
        let view = Background_DarkMode()
        view.colorName = "Background_Voucher_DarkTheme"
        view.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 16)
        return view
    }()
    
    private let dateTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GoogleSans-Regular", size: 13)
        label.textColor = #colorLiteral(red: 0.5295057893, green: 0.5291086435, blue: 0.5508569479, alpha: 1)
        label.text = Localize.date()
        return label
    }()
    
    private let transactionDateLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode()
        label.font = UIFont(name: "GoogleSans-Regular", size: 14)
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "closeIcon"), for: .normal)
        button.addTarget(self, action: #selector(popOut), for: .touchUpInside)
        return button
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GoogleSans-Regular", size: 30)
        label.textColor = #colorLiteral(red: 0.1702004969, green: 0.3387943804, blue: 1, alpha: 1)
        return label
    }()
    
    private let transactionStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GoogleSans-Regular", size: 13)
        label.textColor = #colorLiteral(red: 0.1702004969, green: 0.3387943804, blue: 1, alpha: 1)
        return label
    }()
    
    private let bodyTransactionDetailView: Background_DarkMode = {
        let view = Background_DarkMode()
        view.colorName = "Gray_Dark_DarkTheme"
        view.corner = 16
        return view
    }()
    
    private let titleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode()
        label.font = UIFont(name: "GoogleSans-Bold", size: 18)
        label.text = Localize.transaction_details()
        return label
    }()
    
    private let idHeader: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GoogleSans-Regular", size: 13)
        label.textColor = #colorLiteral(red: 0.5295057893, green: 0.5291086435, blue: 0.5508569479, alpha: 1)
        label.text = "ID"
        return label
    }()
    
    private let idTransactionLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode()
        label.font = UIFont(name: "GoogleSans-Regular", size: 15)
        return label
    }()
    
    private let fundHeader: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GoogleSans-Regular", size: 13)
        label.textColor = #colorLiteral(red: 0.5295057893, green: 0.5291086435, blue: 0.5508569479, alpha: 1)
        label.text = Localize.fund()
        return label
    }()
    
    private let fundNameLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode()
        label.font = UIFont(name: "GoogleSans-Regular", size: 15)
        return label
    }()
    
    private let providerHeader: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GoogleSans-Regular", size: 13)
        label.text = Localize.provider()
        label.textColor = #colorLiteral(red: 0.5295057893, green: 0.5291086435, blue: 0.5508569479, alpha: 1)
        return label
    }()
    
    private let provederNameLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode()
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubviews()
        addConstraints()
        addSubviewsBodyView()
        addConstraintsBodyView()
        addbodyTransactionDetailViewSubviews()
        addbodyTransactionDetailViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(transaction: Transaction) {
        
        if let amount = transaction.amount {
            if amount.double == 0.0 {
                self.priceLabel.text = Localize.free()
            }else {
                self.priceLabel.text = "+ € \(amount)"
            }
        }
        transactionStatusLabel.text = transaction.state
        transactionDateLabel.text = transaction.created_at?.dateFormaterNormalDate()
        idTransactionLabel.text = String(transaction.id ?? 0)
        fundNameLabel.text = transaction.fund?.name
        provederNameLabel.text = transaction.organization?.name
    }
}


// MARK: - Add Subviews

extension TransactionOverview {
    func addSubviews() {
        let views = [transpartentView, bodyView]
        views.forEach { (view) in
            addSubview(view)
        }
    }
    
    func addSubviewsBodyView() {
        let views = [dateTitleLabel, transactionDateLabel, closeButton, priceLabel, transactionStatusLabel, bodyTransactionDetailView]
        views.forEach { (view) in
            addSubview(view)
        }
    }
    
    func addbodyTransactionDetailViewSubviews() {
        let views = [titleLabel, idHeader, idTransactionLabel, fundHeader, fundNameLabel, providerHeader, provederNameLabel]
        views.forEach { (view) in
            bodyTransactionDetailView.addSubview(view)
        }
    }
}


// MARK: - Add Constraints

extension TransactionOverview {
    func addConstraints() {
        
        bodyView.snp.makeConstraints { make in
            make.height.equalTo(423)
            make.left.right.bottom.equalTo(self)
        }
        
        transpartentView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self)
        }
    }
    
    func addConstraintsBodyView() {
        
        dateTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyView).offset(20)
            make.left.equalTo(bodyView).offset(18)
        }
        
        transactionDateLabel.snp.makeConstraints { make in
            make.top.equalTo(dateTitleLabel.snp.bottom)
            make.left.equalTo(bodyView).offset(18)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(dateTitleLabel)
            make.right.equalTo(bodyView).offset(-18)
            make.width.height.equalTo(44)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyView).offset(79)
            make.centerX.equalTo(bodyView)
        }
        
        transactionStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(10)
            make.centerX.equalTo(bodyView)
        }
        
        bodyTransactionDetailView.snp.makeConstraints { make in
            make.left.equalTo(bodyView).offset(10)
            make.right.equalTo(bodyView).offset(-10)
            make.bottom.equalTo(bodyView).offset(-30)
            make.top.equalTo(transactionStatusLabel.snp.bottom).offset(20)
            make.height.equalTo(228)
        }
    }
    
    func addbodyTransactionDetailViewConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyTransactionDetailView).offset(23)
            make.left.equalTo(bodyTransactionDetailView).offset(25)
        }
        
        idHeader.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.left.equalTo(bodyTransactionDetailView).offset(25)
        }
        
        idTransactionLabel.snp.makeConstraints { make in
            make.top.equalTo(idHeader.snp.bottom).offset(3)
            make.left.equalTo(bodyTransactionDetailView).offset(25)
        }
        
        fundHeader.snp.makeConstraints { make in
            make.top.equalTo(idTransactionLabel.snp.bottom).offset(9)
            make.left.equalTo(bodyTransactionDetailView).offset(25)
        }
        
        fundNameLabel.snp.makeConstraints { make in
            make.top.equalTo(fundHeader.snp.bottom).offset(3)
            make.left.equalTo(bodyTransactionDetailView).offset(25)
        }
        
        providerHeader.snp.makeConstraints { make in
            make.top.equalTo(fundNameLabel.snp.bottom).offset(16)
            make.left.equalTo(bodyTransactionDetailView).offset(25)
        }
        
        provederNameLabel.snp.makeConstraints { make in
            make.top.equalTo(providerHeader.snp.bottom).offset(3)
            make.left.equalTo(bodyTransactionDetailView).offset(25)
        }
    }
}

// MARK: - Animations

extension TransactionOverview {
    func popIn(){
        self.isHidden = false
        self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animateKeyframes(withDuration: 0.2, delay: 0.0, options: UIView.KeyframeAnimationOptions.calculationModeDiscrete, animations: {
            self.transform = .identity
        }, completion:{(_ finish : Bool) in
            
        })
        
    }
    
    @objc func popOut() {
        self.transform = .identity
        UIView.animateKeyframes(withDuration: 0.2, delay: 0.0, options: UIView.KeyframeAnimationOptions.calculationModeDiscrete, animations: {
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }, completion:{(_ finish : Bool) in
            self.isHidden = true}
        )
    }
}
