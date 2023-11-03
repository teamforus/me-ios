//
//  MSuccessRegisterViewController.swift
//  Me-iOS
//
//  Created by Daniel Tcacenco on 3/2/20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MSuccessRegisterViewController: UIViewController {
    
    var navigator: Navigator
    
    // MARK: - Parameters
    var titleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansMedium(size: 36)
        label.text = Localize.success_login()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var iconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = R.image.ilustrationCheckmark()
        imageView.contentMode = .scaleAspectFill
        return imageView
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
    
    // MARK: - Init
    init(navigator: Navigator) {
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
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
        setupActions()
    }
}

extension MSuccessRegisterViewController {
    // MARK: - Add Subviews
    private func addSubviews() {
        let views = [titleLabel, iconView, nextButton]
        views.forEach { view in
            self.view.addSubview(view)
        }
    }
}

extension MSuccessRegisterViewController {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(97)
            make.left.top.equalTo(self.view.safeAreaLayoutGuide).offset(17)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-17)
        }
        
        iconView.snp.makeConstraints { make in
            make.height.equalTo(332)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.centerY.equalTo(self.view)
        }
        
        nextButton.snp.makeConstraints { make in
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(33)
            make.right.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-33)
            make.height.equalTo(51)
        }
    }
}

extension MSuccessRegisterViewController {
    // MARK: - Setup Actions
    private func setupActions() {
        nextButton.actionHandleBlock = { [weak self] (_) in
            self?.navigator.navigate(to: .enablePersonalInfo)
        }
    }
}
