//
//  TextFieldTableViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 29.06.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    static let identifier = "TextFieldTableViewCell"
    
    // MARK: - Paramters
    private let textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.font = R.font.googleSansRegular(size: 16)
        return textField
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(placeHolder: String) {
        textField.setPlaceholderColor(with: placeHolder, and: .lightGray)
    }
}

// MARK: - Setup View
extension TextFieldTableViewCell {
    private func setupView() {
        self.contentView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self.contentView)
        }
    }
}
