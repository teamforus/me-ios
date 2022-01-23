//
//  MDeleteAccountViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 23.01.22.
//  Copyright © 2022 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MDeleteAccountViewController: UIViewController {
    var email: String
    
    let closeButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.setImage(R.image.closeIcon(), for: .normal)
        return button
    }()
    
    let secureIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = R.image.secure()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.text = Localize.delete_account()
        label.font = R.font.googleSansMedium(size: 36)
        label.numberOfLines = 2
        return label
    }()
    
    let titleDescriptionLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansBold(size: 17)
        label.text = Localize.title_delete_description()
        label.numberOfLines = 0
        return label
    }()
    
    let descriptionLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansRegular(size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    let deleteAccountButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.backgroundColor = #colorLiteral(red: 0.9981481433, green: 0.8903694749, blue: 0.887986362, alpha: 1)
        button.setTitle(Localize.delete_account(), for: .normal)
        button.rounded(cornerRadius: 6)
        button.titleLabel?.font = R.font.googleSansMedium(size: 14)
        button.setTitleColor(#colorLiteral(red: 0.9930519462, green: 0.1903776526, blue: 0.1909822822, alpha: 1), for: .normal)
        return button
    }()
    
    let cancelAccountButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.backgroundColor = #colorLiteral(red: 0.9450981021, green: 0.9450981021, blue: 0.9450981021, alpha: 1)
        button.setTitle(Localize.cancel(), for: .normal)
        button.rounded(cornerRadius: 6)
        button.titleLabel?.font = R.font.googleSansMedium(size: 14)
        button.setTitleColor(#colorLiteral(red: 0.1902817786, green: 0.3693829775, blue: 0.9930066466, alpha: 1), for: .normal)
        return button
    }()
    
    init(email: String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        setupView()
    }
    
    private func setupView() {
        if #available(iOS 11.0, *) {
            self.view.backgroundColor = UIColor(named: "Background_DarkTheme")
        } else {}
        
        let mainString = String(format: Localize.description_delete(email))
        let range = (mainString as NSString).range(of: email)
        
        let attributedString = NSMutableAttributedString(string:mainString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.2078431373, green: 0.3921568627, blue: 0.9764705882, alpha: 1) , range: range)
        
        descriptionLabel.attributedText = attributedString
        
        setupActions()
    }
    
}

// MARK: - Add Subviews
extension MDeleteAccountViewController {
    private func addSubviews() {
        let views = [closeButton, secureIcon, titleLabel, titleDescriptionLabel, descriptionLabel, deleteAccountButton, cancelAccountButton]
        
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
    }
}

// MARK: - Setup Constraints
extension MDeleteAccountViewController {
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            secureIcon.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 77),
            secureIcon.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 17),
            secureIcon.heightAnchor.constraint(equalToConstant: 44),
            secureIcon.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 77),
            titleLabel.leadingAnchor.constraint(equalTo: self.secureIcon.trailingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            titleDescriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 18),
            titleDescriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 21),
            titleDescriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -21)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: self.titleDescriptionLabel.bottomAnchor, constant: 11),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 21),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -21)
        ])
        
        NSLayoutConstraint.activate([
            deleteAccountButton.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 30),
            deleteAccountButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 21),
            deleteAccountButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -21),
            deleteAccountButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            cancelAccountButton.topAnchor.constraint(equalTo: self.deleteAccountButton.bottomAnchor, constant: 20),
            cancelAccountButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 21),
            cancelAccountButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -21),
            cancelAccountButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: - Setup Actions
extension MDeleteAccountViewController {
    private func setupActions() {
        deleteAccountButton.actionHandleBlock = { [weak self] (_) in
            
        }
        
        closeButton.actionHandleBlock = { [weak self] (_) in
            self?.dismiss(animated: true)
        }
        
        cancelAccountButton.actionHandleBlock = { [weak self] (_) in
            self?.dismiss(animated: true)
        }
    }
}
