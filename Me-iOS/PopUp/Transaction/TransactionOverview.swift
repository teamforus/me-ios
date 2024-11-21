//
//  TransactionOverview.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 31.08.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class TransactionOverview: UIView {
    
    var transaction: Transaction?
    
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
    
    private let extraPaymentHeader: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GoogleSans-Regular", size: 13)
        label.text = Localize.extra_payment_title()
        label.isHidden = true
        label.textColor = #colorLiteral(red: 0.5295057893, green: 0.5291086435, blue: 0.5508569479, alpha: 1)
        return label
    }()
    
    private let extraPriceLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode()
        label.isHidden = true
        return label
    }()
    
    let noteHeader: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GoogleSans-Regular", size: 13)
        label.text = Localize.notes()
        label.textColor = #colorLiteral(red: 0.5295057893, green: 0.5291086435, blue: 0.5508569479, alpha: 1)
        return label
    }()
    
    let noteNameLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode()
        return label
    }()
    
    // MARK: - Init
    
     init( transaction: Transaction) {
        self.transaction = transaction
        
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
    
    func configure() {
        guard let transaction = transaction else { return }
        if let amount = transaction.amount {
            if amount.double == 0.0 {
                self.priceLabel.text = Localize.free()
            }else {
                self.priceLabel.text = "+ € \(amount)"
            }
        }
        
        switch transaction.state {
        case "pending":
            self.transactionStatusLabel.text = Localize.pending()
        case "success":
            self.transactionStatusLabel.text = Localize.success()
        default:
            self.transactionStatusLabel.text = ""
        }
        transactionDateLabel.text = transaction.created_at?.dateFormaterHourDate()
        idTransactionLabel.text = String(transaction.id ?? 0)
        fundNameLabel.text = transaction.fund?.name
        provederNameLabel.text = transaction.organization?.name
        noteNameLabel.text = transaction.note
        
        if let price = transaction.amount_extra_cash, price != "0.00" {
            extraPriceLabel.isHidden = false
            extraPaymentHeader.isHidden = false
            extraPriceLabel.text = "€\(price)"
        }
    }
}


// MARK: - Add Subviews

extension TransactionOverview {
    func addSubviews() {
        let views = [transpartentView,
                     bodyView]
        
        views.forEach { (view) in
            addSubview(view)
        }
    }
    
    func addSubviewsBodyView() {
        let views = [dateTitleLabel,
                     transactionDateLabel,
                     closeButton,
                     priceLabel,
                     transactionStatusLabel,
                     bodyTransactionDetailView]
        
        views.forEach { (view) in
            addSubview(view)
        }
    }
    
    func addbodyTransactionDetailViewSubviews() {
        let views = [titleLabel,
                     idHeader,
                     idTransactionLabel,
                     fundHeader,
                     fundNameLabel,
                     providerHeader,
                     provederNameLabel,
                     extraPaymentHeader,
                     extraPriceLabel,
                     noteHeader,
                     noteNameLabel]
        
        views.forEach { (view) in
            bodyTransactionDetailView.addSubview(view)
        }
    }
}


// MARK: - Add Constraints

extension TransactionOverview {
    func addConstraints() {
        
        var heigt = 423
        
        if let _ = transaction?.note {
            heigt += 50
        }
        
        if let price = transaction?.amount_extra_cash, price != "0.00" {
            heigt += 50
        }
        
        bodyView.snp.makeConstraints { make in
            make.height.equalTo(heigt)
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
        
        var heigt = 228
        
        if let _ = transaction?.note {
            heigt += 50
        }
        
        if let price = transaction?.amount_extra_cash, price != "0.00" {
            heigt += 50
        }
        
        bodyTransactionDetailView.snp.makeConstraints { make in
            make.left.equalTo(bodyView).offset(10)
            make.right.equalTo(bodyView).offset(-10)
            make.bottom.equalTo(bodyView).offset(-30)
            make.top.equalTo(transactionStatusLabel.snp.bottom).offset(20)
            make.height.equalTo(heigt)
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
        
        extraPaymentHeader.snp.makeConstraints { make in
            make.top.equalTo(provederNameLabel.snp.bottom).offset(16)
            make.left.equalTo(bodyTransactionDetailView).offset(25)
        }
        
        extraPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(extraPaymentHeader.snp.bottom).offset(3)
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
