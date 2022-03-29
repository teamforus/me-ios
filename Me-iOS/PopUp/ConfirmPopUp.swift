//
//  ConfirmPopUp.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 24.01.22.
//  Copyright © 2022 Tcacenco Daniel. All rights reserved.
//

import UIKit

class ConfirmPopUp: UIView {
    var title: String
    var subTitle: String
    var icon: UIImage
    
    // MARK: - Properties
    private let blurView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()
    
    private let bodyView: CustomCornerUIView = {
        let view = CustomCornerUIView(frame: .zero)
        view.colorName = "WhiteBackground_DarkTheme"
        view.cornerRadius = 16
        return view
    }()
    
    private let titleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansMedium(size: 24)
        label.textAlignment = .center
        return label
    }()
    
    private let subTitleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = R.font.googleSansRegular(size: 15)
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = R.image.iconsBugreport()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
     let cancelButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.setTitleColor(#colorLiteral(red: 0.1902817786, green: 0.3693829775, blue: 0.9930066466, alpha: 1), for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = R.font.googleSansMedium(size: 13)
        button.setTitle(Localize.cancel().uppercased(), for: .normal)
        return button
    }()
    
     let confirmButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.backgroundColor = #colorLiteral(red: 0.9930519462, green: 0.1903776526, blue: 0.1909822822, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = R.font.googleSansMedium(size: 13)
        button.setTitle(Localize.delete_action().uppercased(), for: .normal)
        button.rounded(cornerRadius: 6)
        return button
    }()
    
    // MARK: - Init
    init(title: String, subTitle: String, icon: UIImage) {
        self.title = title
        self.subTitle = subTitle
        self.icon = icon
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        iconImageView.image = icon
    }
    
}

// MARK: - Add Subviews
extension ConfirmPopUp {
    private func addSubviews() {
        let views = [blurView, bodyView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        addBodyViewSubviews()
    }
    
    private func addBodyViewSubviews() {
        let views = [titleLabel, subTitleLabel, iconImageView, confirmButton, cancelButton]
        
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.bodyView.addSubview(view)
        }
    }
}

// MARK: - Setup Constraints
extension ConfirmPopUp {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            bodyView.heightAnchor.constraint(equalToConstant: 358),
            bodyView.widthAnchor.constraint(equalToConstant: 335),
            bodyView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            bodyView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.bodyView.topAnchor, constant: 26),
            titleLabel.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor, constant: 17),
            titleLabel.trailingAnchor.constraint(equalTo: self.bodyView.trailingAnchor, constant: -17)
        ])
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 40),
            iconImageView.centerXAnchor.constraint(equalTo: self.bodyView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: self.iconImageView.bottomAnchor, constant: 23),
            subTitleLabel.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor, constant: 17),
            subTitleLabel.trailingAnchor.constraint(equalTo: self.bodyView.trailingAnchor, constant: -17)
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: self.bodyView.bottomAnchor, constant: -19),
            confirmButton.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor, constant: 23),
            confirmButton.widthAnchor.constraint(equalToConstant: 140),
            confirmButton.heightAnchor.constraint(equalToConstant: 46)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: self.bodyView.bottomAnchor, constant: -19),
            cancelButton.widthAnchor.constraint(equalToConstant: 140),
            cancelButton.heightAnchor.constraint(equalToConstant: 46),
            cancelButton.leadingAnchor.constraint(equalTo: self.confirmButton.trailingAnchor, constant: 6)
        ])
    }
}
