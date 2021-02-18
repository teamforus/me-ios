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
    
    private let bodyView: UIView = {
        let bodyView = UIView(frame: .zero)
        bodyView.backgroundColor = .white
        return bodyView
    }()
    
    private let emailButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.backgroundColor = #colorLiteral(red: 0.9449954033, green: 0.9451572299, blue: 0.9449852109, alpha: 1)
        return button
    }()
    
    private let voucherInfoButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.backgroundColor = #colorLiteral(red: 0.9449954033, green: 0.9451572299, blue: 0.9449852109, alpha: 1)
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}

extension MInfoVoucherTableViewCell {
    func addSubviews() {
        let views = [bodyView, emailButton, voucherInfoButton]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(view)
        }
    }
    func setupConstraints(){
        NSLayoutConstraint.activate([
            bodyView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            bodyView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            bodyView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant:  0),
            bodyView.heightAnchor.constraint(equalToConstant: 70),
            bodyView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            emailButton.topAnchor.constraint(equalTo: self.bodyView.topAnchor, constant: 11),
            emailButton.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor, constant: 20),
            emailButton.bottomAnchor.constraint(equalTo: self.bodyView.bottomAnchor, constant: -12.5),
            emailButton.heightAnchor.constraint(equalToConstant: 46),
        ])
        
        NSLayoutConstraint.activate([
            voucherInfoButton.topAnchor.constraint(equalTo: self.bodyView.topAnchor, constant: 11),
            voucherInfoButton.trailingAnchor.constraint(equalTo: self.bodyView.trailingAnchor, constant:  -17),
            voucherInfoButton.centerYAnchor.constraint(equalTo: self.emailButton.centerYAnchor),
            voucherInfoButton.leadingAnchor.constraint(equalTo: self.emailButton.trailingAnchor, constant: 12),
            voucherInfoButton.heightAnchor.constraint(equalToConstant: 46),
        ])
    }
    
}
