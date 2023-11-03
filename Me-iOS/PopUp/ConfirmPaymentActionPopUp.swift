//
//  ConfirmPaymentActionPopUp.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 06.08.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class ConfirmPaymentActionPopUp: UIView {

    let backgroundView: Background_DarkMode = {
        let view = Background_DarkMode(frame: .zero)
        view.colorName = "Black_Light_DarkTheme"
        return view
    }()
    
    let bodyView: Background_DarkMode = {
        let view = CustomCornerUIView(frame: .zero)
        view.cornerRadius = 16
        return view
    }()
    
    let titleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        return label
    }()
    
    let amountLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        return label
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(frame: .zero)
        return button
    }()
    
    let confirmButton: ShadowButton = {
        let button = ShadowButton(frame: .zero)
        button.cornerRadius = 6
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

}

// MARK: - Init View

extension ConfirmPaymentActionPopUp {
    func initView() {
        addSubviews()
        addSubviewsForBody()
        addConstraints()
        addConstraintsForBody()
    }
}

// MARK: - Add Subviews

extension ConfirmPaymentActionPopUp {
    func addSubviews() {
        let views = [backgroundView, bodyView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
    }
    
    func addSubviewsForBody() {
        let views = [titleLabel, amountLabel, cancelButton, confirmButton]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
    }
}

 // MARK: - Add Constraints

extension ConfirmPaymentActionPopUp {
    func addConstraints() {
        
        backgroundView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self)
        }
        
        bodyView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(250)
            make.center.equalTo(self)
        }
    }
    
    func addConstraintsForBody() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyView).offset(26)
            make.left.equalTo(bodyView).offset(53)
            make.right.equalTo(bodyView).offset(-53)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.left.equalTo(bodyView).offset(19)
            make.right.equalTo(bodyView).offset(-19)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalTo(bodyView).offset(-19)
            make.left.equalTo(bodyView).offset(19)
            make.height.equalTo(46)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.bottom.right.equalTo(bodyView).offset(-19)
            make.left.equalTo(confirmButton.snp.right).offset(6)
            make.height.equalTo(46)
        }
    }
}
