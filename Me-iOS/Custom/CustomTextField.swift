//
//  CustomTextField.swift
//
//  Created by Daniel Tcacenco on 05.02.2024.
//

import UIKit

class CustomTextField: UIView {
    
    var textHandleBlock: ((_ textField: UITextField) -> ())?

    private let textField: UITextField = {
        let textField = UITextField(frame: .zero)
//        textField.font = .set(.regular, size: 16)
        textField.backgroundColor = .white
        return textField
    }()
    
    private let bodyView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private let icon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
//        imageView.tintColor = Color.iconUnseleted
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Medium", size: 11)
        return label
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Regular", size: 11)
        label.textColor = UIColor(hex: "#DB1E0B")
        label.isHidden = true
        return label
    }()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    private func setupView() {
        addSubviews()
        setupConstraints()
        let tap = UITapGestureRecognizer(target: self, action: #selector(enableFirstResponse))
        addGestureRecognizer(tap)
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func setup(title: String, placeHolder: String, icon: UIImage?, type: UIKeyboardType, isSecureTextEntry: Bool = false) {
        titleLabel.text = title
        textField.keyboardType = type
        textField.placeholder = placeHolder
        textField.isSecureTextEntry = isSecureTextEntry
        self.icon.image = icon?.withRenderingMode(.alwaysTemplate)
        
        if icon == nil {
            textField.snp.makeConstraints { make in
                make.left.equalTo(self.bodyView).offset(16)
                make.right.equalTo(self.bodyView).offset(-12)
                make.centerY.equalTo(self.bodyView)
            }
        }
    }
    
    func setError(with text: String) {
        bodyView.backgroundColor = UIColor(hex: "#FFF8F8")
        textField.backgroundColor = UIColor(hex: "#FFF8F8")
        bodyView.layer.borderColor = UIColor(hex: "#DB1E0B").cgColor
        errorLabel.text = text
        errorLabel.isHidden = false
    }
    
    @objc private func enableFirstResponse() {
        textField.becomeFirstResponder()
    }
}

// MARK: - UITextFieldDelegate
extension CustomTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        fieldHasSelected(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        fieldHasSelected(false)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        textHandleBlock?(textField)
    }
    
    private func fieldHasSelected(_ selected: Bool) {
//        self.bodyView.border(with: 1, and: selected ? Colors.brand : Colors.fieldBorder)
//        icon.tintColor = selected ? Colors.brand : Colors.iconUnseleted
    }
}

// MARK: - Add Subview
extension CustomTextField {
    private func addSubviews(){
        let views = [titleLabel,
                     bodyView,
                     errorLabel]
        views.forEach { view in
            self.addSubview(view)
        }
        
        let bodyViews = [icon,
                         textField]
        bodyViews.forEach { view in
            self.bodyView.addSubview(view)
        }
    }
}
// MARK: - Setup Constraints
extension CustomTextField {
    private func setupConstraints(){
        titleLabel.snp.makeConstraints { make in
            make.left.top.right.equalTo(self)
        }
        
        bodyView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(6)
            make.height.equalTo(50)
            make.left.right.equalTo(self)
        }
        
        icon.snp.makeConstraints { make in
            make.centerY.equalTo(self.bodyView)
            make.left.equalTo(self.bodyView).offset(16)
            make.height.width.equalTo(20)
        }
        
        textField.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(12)
            make.right.equalTo(self.bodyView).offset(-12)
            make.centerY.equalTo(self.bodyView)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.top.equalTo(bodyView.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }
    }
}
