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
    var fieldType: PaymentRowType!
    
    
    var amountValue: ((String)->())?
    var noteValue: ((String)->())?
    
    // MARK: - Paramters
    private let textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.font = R.font.googleSansRegular(size: 16)
        textField.backgroundColor = Color.fieldBg
        textField.rounded(cornerRadius: 6)
        textField.setLeftPaddingPoints(16)
        textField.addTarget(self, action: #selector(textFieldDidChangeEditing(_:)), for: .editingChanged)
        return textField
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(placeHolder: String, fieldType: PaymentRowType) {
        self.fieldType = fieldType
        textField.keyboardType = fieldType == .amount ? .decimalPad : .default
        textField.setPlaceholderColor(with: placeHolder, and: .lightGray)
    }
}

// MARK: - Setup View
extension TextFieldTableViewCell {
    private func setupView() {
        textField.delegate = self
        self.contentView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.left.top.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.bottom.equalTo(self.contentView)
        }
    }
}

// MARK: - UITextFieldDelegate
extension TextFieldTableViewCell: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if fieldType == .amount {
            var dotString = ""
            let limitAfterDot = 2
            if String.languageCode == "en"{
                
                dotString = "."
                
            }else if String.languageCode == "nl" {
                
                dotString = ","
            }
            
            if let text = textField.text {
                let isDeleteKey = string.isEmpty
                
                if !isDeleteKey {
                    if text.contains(dotString) {
                        let countdots = textField.text!.components(separatedBy: dotString).count - 1
                        
                        if countdots > 0 && string == dotString
                        {
                            return false
                        }
                        if text.components(separatedBy: dotString)[1].count == limitAfterDot {
                            
                            return false
                        }
                    }
                }
            }
            amountValue?(textField.text! + string)
        }else {
            noteValue?(textField.text! + string)
        }
        return true
    }
    
    @objc private func textFieldDidChangeEditing(_ textField: UITextField) {
        if fieldType == .amount {
            
        }else {
            
        }
    }
    
}
