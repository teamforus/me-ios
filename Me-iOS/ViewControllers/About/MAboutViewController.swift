//
//  MAboutViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 6/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MAboutViewController: UIViewController {
    var titleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansBold(size: 38)
        label.text = Localize.about_me()
        return label
    }()
    
    var descriptionLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansRegular(size: 16)
        label.numberOfLines = 0
        label.text = Localize.description_about()
        return label
    }()
    
    var logoImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = R.image.logo_icon()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var nameCompany: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansBold(size: 17)
        label.text = "Me"
        return label
    }()
    
    var dateCompany: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansRegular(size: 14)
        label.text = "Forus"
        label.textColor = Color.grayText
        return label
    }()
    
    var closeButton: CloseButton_DarkMode = {
        let actionButton = CloseButton_DarkMode(frame: .zero)
        return actionButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        setupUI()
    }
    
    private func setupUI() {
        setupAccessibility()
        if #available(iOS 11.0, *) {
            self.view.backgroundColor = UIColor(named: "Background_DarkTheme")
        } else {
        }
        closeButton.actionHandleBlock = { [weak self] (_) in
            self?.dismiss(animated: true)
        }
    }
}

extension MAboutViewController {
    // MARK: - Add Subviews
    private func addSubviews() {
        let views = [closeButton, titleLabel, descriptionLabel, logoImage, nameCompany, dateCompany]
        views.forEach { view in
            self.view.addSubview(view)
        }
    }
}

extension MAboutViewController {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.top.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(60)
            make.left.equalTo(self.view).offset(17)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.left.equalTo(self.view).offset(12)
            make.right.equalTo(self.view).offset(-16)
        }
        
        logoImage.snp.makeConstraints { make in
            make.left.equalTo(self.view).offset(17)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            make.width.height.equalTo(40)
        }
        
        nameCompany.snp.makeConstraints { make in
            make.top.equalTo(logoImage)
            make.left.equalTo(logoImage.snp.right).offset(17)
        }
        
        dateCompany.snp.makeConstraints { make in
            make.top.equalTo(nameCompany.snp.bottom).offset(11)
            make.left.equalTo(logoImage.snp.right).offset(17)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
        }
    }
}

// MARK: - Accessibility Protocol

extension MAboutViewController: AccessibilityProtocol {
    func setupAccessibility() {
        closeButton.setupAccesibility(description: "Close", accessibilityTraits: .button)
    }
}
