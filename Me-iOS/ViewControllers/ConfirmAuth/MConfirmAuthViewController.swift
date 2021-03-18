//
//  MConfirmAuthViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 12/24/20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MConfirmAuthViewController: UIViewController {
  
  weak var delegate: QRControllerDelegate!
  
  // MARK: - Properties
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
    imageView.contentMode = .scaleAspectFill
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
    addSubviews()
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
  private func addSubviews() {
    let views = [titleLabel, iconImageView, descriptionLabel, confirmButton, cancelButton]
    views.forEach { (view) in
      view.translatesAutoresizingMaskIntoConstraints = false
      self.view.addSubview(view)
    }
  }
}

extension MConfirmAuthViewController {
  // MARK: - Setup Constraints
  private func setupConstraints() {
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 92),
      titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 17),
      titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -17)
    ])
    
    NSLayoutConstraint.activate([
      iconImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
      iconImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      iconImageView.widthAnchor.constraint(equalToConstant: 281),
      iconImageView.heightAnchor.constraint(equalToConstant: 281)
    ])
    
    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 42),
      descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 21),
      descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -21)
    ])
    
    NSLayoutConstraint.activate([
      confirmButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 25),
      confirmButton.heightAnchor.constraint(equalToConstant: 50),
      confirmButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 31),
      confirmButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -31)
    ])
    
    NSLayoutConstraint.activate([
      cancelButton.topAnchor.constraint(equalTo: confirmButton.bottomAnchor, constant: 3),
      cancelButton.heightAnchor.constraint(equalToConstant: 50),
      cancelButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 31),
      cancelButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -31)
    ])
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
