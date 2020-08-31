//
//  TransactionOverview.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 31.08.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class TransactionOverview: UIView {
    
    let transpartentView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        return view
    }()
    
    let bodyView: Background_DarkMode = {
        let view = Background_DarkMode()
        view.colorName = "RecordBackgroundDetail_DarkTheme"
        return view
    }()
    
    let dateTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GoogleSans-Regular", size: 13)
        label.textColor = #colorLiteral(red: 0.5295057893, green: 0.5291086435, blue: 0.5508569479, alpha: 1)
        return label
    }()
    
    let transactionDateLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode()
        label.font = UIFont(name: "GoogleSans-Regular", size: 14)
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "closeIcon"), for: .normal)
        button.addTarget(self, action: #selector(popOut), for: .touchUpInside)
        return button
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GoogleSans-Regular", size: 30)
        label.textColor = #colorLiteral(red: 0.1702004969, green: 0.3387943804, blue: 1, alpha: 1)
        return label
    }()
    
    let transactionStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GoogleSans-Regular", size: 13)
        label.textColor = #colorLiteral(red: 0.1702004969, green: 0.3387943804, blue: 1, alpha: 1)
        return label
    }()
    
    let bodyTransactionDetailView: CustomCornerUIView = {
        let view = CustomCornerUIView()
        view.cornerRadius = 16
        view.colorName = "Background_Voucher_DarkTheme"
        return view
    }()
    
    let titleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode()
        label.font = UIFont(name: "GoogleSans-Bold", size: 18)
        return label
    }()
    
    let idHeader: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GoogleSans-Regular", size: 13)
        label.textColor = #colorLiteral(red: 0.5295057893, green: 0.5291086435, blue: 0.5508569479, alpha: 1)
        return label
    }()
    
    let idTransactionLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode()
        label.font = UIFont(name: "GoogleSans-Regular", size: 15)
        return label
    }()
    
    let fundHeader: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GoogleSans-Regular", size: 13)
        label.textColor = #colorLiteral(red: 0.5295057893, green: 0.5291086435, blue: 0.5508569479, alpha: 1)
        return label
    }()
    
    let fundNameLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode()
        label.font = UIFont(name: "GoogleSans-Regular", size: 15)
        return label
    }()
    
    let providerHeader: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GoogleSans-Regular", size: 13)
        label.textColor = #colorLiteral(red: 0.5295057893, green: 0.5291086435, blue: 0.5508569479, alpha: 1)
        return label
    }()
    
    let provederNameLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode()
        return label
    }()
    
    // MARK: - Init
    
    convenience init(transaction: Transaction) {
        self.init(frame: .zero)
        addSubviews()
        addConstraints()
        addSubviewsBodyView()
        addConstraintsBodyView()
        addbodyTransactionDetailViewSubviews()
        addbodyTransactionDetailViewConstraints()
    }
}


// MARK: - Add Subviews

extension TransactionOverview {
    func addSubviews() {
        let views = [transpartentView, bodyView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
    
    func addSubviewsBodyView() {
        let views = [dateTitleLabel, transactionDateLabel, closeButton, priceLabel, transactionStatusLabel, bodyTransactionDetailView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
    
    func addbodyTransactionDetailViewSubviews() {
        let views = [titleLabel, idHeader, idTransactionLabel, fundHeader, fundNameLabel, providerHeader, provederNameLabel]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            bodyTransactionDetailView.addSubview(view)
        }
    }
    
}


// MARK: - Add Constraints

extension TransactionOverview {
    func addConstraints() {
        NSLayoutConstraint.activate([
            bodyView.heightAnchor.constraint(equalToConstant: 423),
            bodyView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            bodyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            bodyView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            transpartentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            transpartentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            transpartentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            transpartentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
    
    func addConstraintsBodyView() {
        NSLayoutConstraint.activate([
            dateTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            dateTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18)
        ])
        
        NSLayoutConstraint.activate([
            transactionDateLabel.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 0),
            transactionDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 79),
            priceLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            transactionStatusLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            transactionStatusLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            bodyTransactionDetailView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            bodyTransactionDetailView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10),
            bodyTransactionDetailView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 13),
            bodyTransactionDetailView.topAnchor.constraint(equalTo: self.transactionStatusLabel.bottomAnchor, constant: 20),
            bodyTransactionDetailView.heightAnchor.constraint(equalToConstant: 228)
        ])
    }
    
    func addbodyTransactionDetailViewConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 23),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            idHeader.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            idHeader.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            idTransactionLabel.topAnchor.constraint(equalTo: idHeader.bottomAnchor, constant: 3),
            idTransactionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            fundHeader.topAnchor.constraint(equalTo: idTransactionLabel.bottomAnchor, constant: 9),
            fundHeader.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            fundNameLabel.topAnchor.constraint(equalTo: fundHeader.bottomAnchor, constant: 3),
            fundNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            providerHeader.topAnchor.constraint(equalTo: fundNameLabel.bottomAnchor, constant: 16),
            providerHeader.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            provederNameLabel.topAnchor.constraint(equalTo: self.providerHeader.bottomAnchor, constant: 3),
            provederNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25)
        ])
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
