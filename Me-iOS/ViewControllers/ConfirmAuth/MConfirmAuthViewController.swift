//
//  MConfirmAuthViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 12/24/20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MConfirmAuthViewController: UIViewController {
    
    var delegate: QRControllerDelegate!
    var heightConstraintsBody: NSLayoutConstraint!
    
    // MARK: - Properties
    
    let scrollView: BackgroundScrollView_DarkMode = {
        let scrollView = BackgroundScrollView_DarkMode(frame: .zero)
        scrollView.colorName = "Background_Voucher_DarkTheme"
        
        if #available(iOS 11.0, *) {
            
        } else {
            // Fallback on earlier versions
        }
        return scrollView
    }()
    
    let bodyView: Background_DarkMode = {
        let view = Background_DarkMode(frame: .zero)
        view.colorName = "Background_Voucher_DarkTheme"
        return view
    }()
    
    private let titleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansMedium(size: 36)
        label.text = Localize.do_you_want_to_login()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = R.image.iconCheckAuthorize()
        return imageView
    }()
    
    private let descriptionLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansRegular(size: 16)
        label.text = Localize.description_of_auth_anothe_device()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let confirmButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.backgroundColor = #colorLiteral(red: 0.1918309331, green: 0.3696506619, blue: 0.9919955134, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = R.font.googleSansBold(size: 14)
        button.setTitle(Localize.i_want_to_login().uppercased(), for: .normal)
        button.rounded(cornerRadius: 9)
        return button
    }()
    
    private let cancelButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.setTitleColor(#colorLiteral(red: 0.4654871821, green: 0.5013635755, blue: 0.5430076122, alpha: 1), for: .normal)
        button.titleLabel?.font = R.font.googleSansRegular(size: 14)
        button.setTitle(Localize.no_thanks(), for: .normal)
        return button
    }()
    
    
    // MARK: - Setup View
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setupConstraints()
        setupUI()
    }
    
    private func setupUI() {
        setupActions()
        if #available(iOS 11.0, *) {
            self.view.backgroundColor = UIColor(named: "Background_DarkTheme")
        } else {
        }
    }
}

extension MConfirmAuthViewController {
    // MARK: - Add Subviews
    private func addSubview() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(bodyView)
        addBodySubviews()
    }
    
    private func addBodySubviews() {
        let views = [titleLabel, iconImageView, descriptionLabel, confirmButton, cancelButton]
        views.forEach { (view) in
            self.bodyView.addSubview(view)
        }
    }
}

extension MConfirmAuthViewController {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.view)
        }
            bodyView.snp.makeConstraints { make in
                make.bottom.right.left.top.equalTo(self.scrollView)
                make.height.width.equalTo(self.view)
            }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.bodyView.safeAreaLayoutGuide).offset(12)
            make.left.equalTo(self.bodyView).offset(17)
            make.right.equalTo(self.bodyView).offset(-17)
            make.height.equalTo(160)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.centerX.equalTo(self.bodyView)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(42)
            make.left.equalTo(self.bodyView).offset(21)
            make.right.equalTo(self.bodyView).offset(-21)
            make.height.equalTo(120)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.left.equalTo(self.bodyView).offset(31)
            make.right.equalTo(self.bodyView).offset(-31)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(confirmButton.snp.bottom).offset(3)
            make.height.equalTo(50)
            make.left.equalTo(bodyView).offset(31)
            make.right.equalTo(bodyView).offset(-31)
            make.bottom.equalTo(bodyView.safeAreaLayoutGuide).offset(-5)
        }
    }
}

extension MConfirmAuthViewController {
    // MARK: - Setup Actions
    private func setupActions() {
        confirmButton.actionHandleBlock = { [weak self] (_) in
            self?.delegate.initAuth()
        }
        
        cancelButton.actionHandleBlock = { [weak self] (_) in
            self?.delegate.cancelAuth()
        }
    }
}
