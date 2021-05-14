//
//  EnablePersonalInformationViewController.swift
//  Me-iOS
//
//  Created by Daniel Tcacenco on 3/2/20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class EnablePersonalInformationViewController: UIViewController {
    
    // MARK: - Parameters
    
    var identificationView: UIView = {
        let view = UIView(frame: .zero)
        view.rounded(cornerRadius: 10)
        view.backgroundColor = Color.backgroundRowView
        return view
    }()
    
    var iconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = R.image.meApp()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var nameSwitchLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansRegular(size: 16)
        label.text = Localize.share_identification_number()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var identificationSwitch: UISwitchCustom = {
        let switchCustom = UISwitchCustom()
        switchCustom.OffTint = Color.offTintSwitch
        switchCustom.onTintColor = Color.onTintSwitch
        switchCustom.addTarget(self, action: #selector(enableSendIndenity(_:)), for: .valueChanged)
        return switchCustom
    }()
    
    var titleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansMedium(size: 36)
        label.text = Localize.sharing_information()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var descriptionLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansRegular(size: 16)
        label.text = Localize.sharing_identification_number_info()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var nextButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(Localize.next(), for: .normal)
        button.backgroundColor = Color.onTintSwitch
        button.rounded(cornerRadius: 9)
        button.titleLabel?.font = R.font.googleSansBold(size: 14)
        button.setupShadow(offset: CGSize(width: 0, height: 10), radius: 10, opacity: 0.2, color: UIColor.black.cgColor)
        return button
    }()
    
    
    // MARK: - Setup View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        setupUI()
    }
    
    private func setupUI() {
        if #available(iOS 11.0, *) {
            self.view.backgroundColor = UIColor(named: "Background_DarkTheme")
        } else {}
        setupAccessibility()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let barVC = segue.destination as? UITabBarController
        let nVC = barVC!.viewControllers![0] as? HiddenNavBarNavigationController
        let vc = nVC?.topViewController as? MVouchersViewController
        vc?.isFromLogin = true
    }
    
    @objc func enableSendIndenity(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: UserDefaultsName.AddressIndentityCrash)
    }
}

extension EnablePersonalInformationViewController {
    // MARK: - Add Subviews
    private func addSubviews() {
        let views = [titleLabel, iconView, descriptionLabel, identificationView, nextButton]
        views.forEach { view in
            self.view.addSubview(view)
        }
        addSubviewsToIdentificationView()
    }
    
    private func addSubviewsToIdentificationView() {
        let views = [nameSwitchLabel, identificationSwitch]
        views.forEach { view in
            self.identificationView.addSubview(view)
        }
    }
}

extension EnablePersonalInformationViewController {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(41)
            make.left.top.equalTo(self.view.safeAreaLayoutGuide).offset(17)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-17)
        }
        
        iconView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(39)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(21)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-21)
        }
        
        identificationView.snp.makeConstraints { make in
            make.height.equalTo(58)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(26)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(33)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-33)
        }
        
        nameSwitchLabel.snp.makeConstraints { make in
            make.left.equalTo(identificationView).offset(18)
            make.centerY.equalTo(identificationView)
        }
        
        identificationSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(identificationView)
            make.right.equalTo(identificationView).offset(-12)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(51)
            make.top.equalTo(identificationView.snp.bottom).offset(21)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(33)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-33)
        }
    }
}

// MARK: - Accessibility Protocol

extension EnablePersonalInformationViewController: AccessibilityProtocol {
    func setupAccessibility() {
        identificationView.setupAccesibility(description: "Turn on/off to send indentification number in crash report, on right side you can enable this option. ", accessibilityTraits: .none)
        identificationSwitch.setupAccesibility(description: "Turn on/off indentification number", accessibilityTraits: .none)
        titleLabel.setupAccesibility(description: Localize.informatie_delen(), accessibilityTraits: .header)
    }
}
