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
    imageView.contentMode = .scaleAspectFill
    imageView.image = Image.checkAuthorizationIcon
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
      button.backgroundColor =  #colorLiteral(red: 0.1918309331, green: 0.3696506619, blue: 0.9919955134, alpha: 1)
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
    
    func addSubview() {
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(bodyView)
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        addBodySubviews()
    }
    
  private func addBodySubviews() {
    let views = [titleLabel, iconImageView, descriptionLabel, confirmButton, cancelButton]
    views.forEach { (view) in
      view.translatesAutoresizingMaskIntoConstraints = false
      self.bodyView.addSubview(view)
    }
  }
}

extension MConfirmAuthViewController {
  // MARK: - Setup Constraints
  private func setupConstraints() {
    
    NSLayoutConstraint.activate([
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
    ])
    
    heightConstraintsBody = bodyView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
    NSLayoutConstraint.activate([
        bodyView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
        bodyView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
        bodyView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
        bodyView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
        bodyView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
       heightConstraintsBody
    ])
    
    if UIDevice.current.screenType == .iPhones_5_5s_5c_SE ||  UIDevice.current.screenType == .iPhones_6_6s_7_8 {
        heightConstraintsBody.isActive = false
        NSLayoutConstraint.activate([
            bodyView.heightAnchor.constraint(equalToConstant: 700)
            
        ])
    }
    
    
    NSLayoutConstraint.activate([
        titleLabel.topAnchor.constraint(equalTo: self.bodyView.safeAreaLayoutGuide.topAnchor, constant: 12),
        titleLabel.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor, constant: 17),
        titleLabel.trailingAnchor.constraint(equalTo: self.bodyView.trailingAnchor, constant: -17),
        titleLabel.heightAnchor.constraint(equalToConstant: 160)
    ])
   
    NSLayoutConstraint.activate([
      iconImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
      iconImageView.centerXAnchor.constraint(equalTo: self.bodyView.centerXAnchor)
    ])
    
    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 42),
      descriptionLabel.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor, constant: 21),
      descriptionLabel.trailingAnchor.constraint(equalTo: self.bodyView.trailingAnchor, constant: -21),
      descriptionLabel.heightAnchor.constraint(equalToConstant: 120)
    ])
    
    NSLayoutConstraint.activate([
        confirmButton.topAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.bottomAnchor, constant: 20),
      confirmButton.heightAnchor.constraint(equalToConstant: 50),
      confirmButton.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor, constant: 31),
      confirmButton.trailingAnchor.constraint(equalTo: self.bodyView.trailingAnchor, constant: -31)
    ])
    
    NSLayoutConstraint.activate([
      cancelButton.topAnchor.constraint(equalTo: confirmButton.bottomAnchor, constant: 3),
      cancelButton.heightAnchor.constraint(equalToConstant: 50),
      cancelButton.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor, constant: 31),
      cancelButton.trailingAnchor.constraint(equalTo: self.bodyView.trailingAnchor, constant: -31),
        cancelButton.bottomAnchor.constraint(equalTo: self.bodyView.safeAreaLayoutGuide.bottomAnchor, constant: -5)
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
