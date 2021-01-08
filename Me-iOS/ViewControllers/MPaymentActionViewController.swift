//
//  MPaymentActionViewController.swift
//  Me-iOS
//
//  Created by Inga Codreanu on 04.09.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MPaymentActionViewController: UIViewController {
  
  var subsidie: Subsidie?
  var organization: AllowedOrganization?
  var fund: Fund?
  var address: String!
  var subsidieOverviewHeightConstraints: NSLayoutConstraint!
  
  // MARK: - Properties
  let scrollView: BackgroundScrollView_DarkMode = {
    let scrollView = BackgroundScrollView_DarkMode(frame: .zero)
    scrollView.colorName = "Background_Voucher_DarkTheme"
    if #available(iOS 11.0, *) {
      scrollView.contentInsetAdjustmentBehavior = .scrollableAxes
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
  
  private let backButton: BackButton_DarkMode = {
    let button = BackButton_DarkMode(frame: .zero)
    button.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
    return button
  }()
  
  private let titleLabel: UILabel_DarkMode = {
    let label = UILabel_DarkMode(frame: .zero)
    label.text = Localize.payment()
    label.textAlignment = .center
    label.font = UIFont(name: "GoogleSans-Medium", size: 17)
    return label
  }()
  
  private let subsidieView: CustomCornerUIView = {
    let view = CustomCornerUIView(frame: .zero)
    view.cornerRadius = 12
    view.shadowRadius = 10
    view.shadowOpacity = 0.1
    view.colorName = "Gray_Dark_DarkTheme"
    return view
  }()
  
  private let subsidieNameLabel: UILabel_DarkMode = {
    let label = UILabel_DarkMode(frame: .zero)
    label.font = UIFont(name: "GoogleSans-Medium", size: 20)
    return label
  }()
  
  private let subsidieImageView: UIImageView = {
    let imageview = UIImageView()
    return imageview
  }()
  
  private let middleView: Background_DarkMode = {
    let view = Background_DarkMode(frame: .zero)
    view.colorName = "Gray_Dark_DarkTheme"
    return view
  }()
  
  
  private let topLineView: Background_DarkMode = {
    let view = Background_DarkMode(frame: .zero)
    view.colorName = "Thin_Light_Gray_DarkTheme"
    return view
  }()
  
  private let bottomLine: Background_DarkMode = {
    let view = Background_DarkMode(frame: .zero)
    view.colorName = "Thin_Light_Gray_DarkTheme"
    return view
  }()
  
  private let lineView: UIView = {
    let view = UIView(frame: .zero)
    view.backgroundColor = #colorLiteral(red: 0.9607282281, green: 0.9607728124, blue: 0.9649807811, alpha: 1)
    return view
  }()
  
  let subsidieOverview: SubsidieOverview = {
    let overview = SubsidieOverview(frame: .zero)
    return overview
  }()
  
  private let noteTextField: TextField = {
    let textField = TextField(frame: .zero)
    textField.font = UIFont(name: "GoogleSans-Regular", size: 15)
    textField.placeholder = Localize.note()
    textField.borderStyle = .none
    textField.left = 10
    textField.layer.cornerRadius = 6
    return textField
  }()
  
  private let payButton: ShadowButton = {
    let button = ShadowButton(frame: .zero)
    button.backgroundColor = #colorLiteral(red: 0.1702004969, green: 0.3387943804, blue: 1, alpha: 1)
    button.cornerRadius = 6
    button.setTitle("Ga over tot betaling", for: .normal)
    button.addTarget(self, action: #selector(showConfirm), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addSubview()
    setupConstraints()
    addBodySubviews()
    setupBodyConstraints()
    addSubsidieSubviews()
    setupSubsidieConstraints()
    addMiddleSubviews()
    setupMiddleConstraints()
    setupView()
  }
  
  func setupView() {
    if let subsidie = self.subsidie {
      setupActions(subsidie: subsidie)
    }
    
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:))))
    
    if #available(iOS 11.0, *) {
      noteTextField.backgroundColor = R.color.lighGray_DarkTheme()
    } else {
      // Fallback on earlier versions
    }
    if let subsidie = subsidie {
      subsidieOverview.configureSubsidie(subsidie: subsidie, and: self)
    }
    addObservers()
  }
  
  func addObservers() {
    NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardDidShow(notification:)),
                                           name: UIResponder.keyboardDidShowNotification, object: nil)
    NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardDidHide(notification:)),
                                           name: UIResponder.keyboardDidHideNotification, object: nil)
  }
  
  func setupActions(subsidie: Subsidie) {
    self.subsidieNameLabel.text = subsidie.name ?? ""
    self.subsidieImageView.loadImageUsingUrlString(urlString: subsidie.photo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
  }
  
  
  // MARK: - Keyboard Observers
  @objc func keyboardDidShow(notification: NSNotification) {
    let info = notification.userInfo
    let keyBoardSize = info![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
    let constantHeight: CGFloat = 60
    scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyBoardSize.height + constantHeight, right: 0.0)
    scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyBoardSize.height + constantHeight, right: 0.0)
  }
  
  @objc func keyboardDidHide(notification: NSNotification) {
    UIView.animate(withDuration: 0.3) {
      self.scrollView.contentInset = UIEdgeInsets.zero
      self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
  }
  
}

// MARK: - Add Subviews

extension MPaymentActionViewController {
  func addSubview() {
    self.view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(bodyView)
    bodyView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func addBodySubviews() {
    let views = [backButton, titleLabel, subsidieView, middleView, payButton]
    views.forEach { (view) in
      view.translatesAutoresizingMaskIntoConstraints = false
      bodyView.addSubview(view)
    }
  }
  
  func addSubsidieSubviews() {
    let views = [subsidieNameLabel, subsidieImageView]
    views.forEach { (view) in
      view.translatesAutoresizingMaskIntoConstraints = false
      subsidieView.addSubview(view)
    }
  }
  
  func addMiddleSubviews() {
    let views = [topLineView, lineView, subsidieOverview, noteTextField, bottomLine]
    views.forEach { (view) in
      view.translatesAutoresizingMaskIntoConstraints = false
      middleView.addSubview(view)
    }
  }
}

// MARK: - Add Constraints

extension MPaymentActionViewController {
  func setupConstraints() {
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
    ])
    
    NSLayoutConstraint.activate([
      bodyView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
      bodyView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
      bodyView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
      bodyView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
      bodyView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
      bodyView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
    ])
  }
  
  func setupBodyConstraints() {
    NSLayoutConstraint.activate([
      backButton.heightAnchor.constraint(equalToConstant: 44),
      backButton.widthAnchor.constraint(equalToConstant: 44),
      backButton.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 10),
      backButton.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 35)
    ])
    
    NSLayoutConstraint.activate([
      titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
      titleLabel.centerXAnchor.constraint(equalTo: bodyView.centerXAnchor)
      
    ])
    
    NSLayoutConstraint.activate([
      subsidieView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 21),
      subsidieView.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor, constant: 17),
      subsidieView.trailingAnchor.constraint(equalTo: self.bodyView.trailingAnchor, constant: -17),
      subsidieView.bottomAnchor.constraint(equalTo: self.middleView.topAnchor, constant: -13),
      subsidieView.heightAnchor.constraint(equalToConstant: 86)
    ])
    
    NSLayoutConstraint.activate([
      middleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      middleView.bottomAnchor.constraint(equalTo: self.payButton.topAnchor, constant: -10),
      middleView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
    ])
    
    NSLayoutConstraint.activate([
      payButton.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 10),
      payButton.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -10),
      payButton.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -30),
      payButton.heightAnchor.constraint(equalToConstant: 46)
    ])
  }
  
  func setupSubsidieConstraints() {
    NSLayoutConstraint.activate([
      subsidieNameLabel.centerYAnchor.constraint(equalTo: subsidieView.centerYAnchor),
      subsidieNameLabel.leadingAnchor.constraint(equalTo: subsidieView.leadingAnchor, constant: 20)
    ])
    
    
    NSLayoutConstraint.activate([
      subsidieImageView.centerYAnchor.constraint(equalTo: subsidieView.centerYAnchor),
      subsidieImageView.heightAnchor.constraint(equalToConstant: 50),
      subsidieImageView.widthAnchor.constraint(equalToConstant: 50),
      subsidieImageView.trailingAnchor.constraint(equalTo: subsidieView.trailingAnchor, constant: -20),
      subsidieImageView.leadingAnchor.constraint(equalTo: subsidieNameLabel.trailingAnchor, constant: 20)
    ])
  }
  
  func setupMiddleConstraints() {
    NSLayoutConstraint.activate([
      topLineView.leadingAnchor.constraint(equalTo: middleView.leadingAnchor),
      topLineView.topAnchor.constraint(equalTo: middleView.topAnchor),
      topLineView.trailingAnchor.constraint(equalTo: middleView.trailingAnchor),
      topLineView.heightAnchor.constraint(equalToConstant: 1)
    ])
    
    NSLayoutConstraint.activate([
      bottomLine.leadingAnchor.constraint(equalTo: middleView.leadingAnchor),
      bottomLine.bottomAnchor.constraint(equalTo: middleView.bottomAnchor),
      bottomLine.trailingAnchor.constraint(equalTo: middleView.trailingAnchor),
      bottomLine.heightAnchor.constraint(equalToConstant: 1)
    ])
    
    
    NSLayoutConstraint.activate([
      lineView.leadingAnchor.constraint(equalTo: middleView.leadingAnchor),
      lineView.topAnchor.constraint(equalTo: middleView.topAnchor, constant: 0),
      lineView.trailingAnchor.constraint(equalTo: middleView.trailingAnchor),
      lineView.heightAnchor.constraint(equalToConstant: 1)
    ])
    
    subsidieOverviewHeightConstraints = subsidieOverview.heightAnchor.constraint(equalToConstant: 320)
    NSLayoutConstraint.activate([
      subsidieOverview.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 22),
      subsidieOverview.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 10),
      subsidieOverview.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -10),
      subsidieOverviewHeightConstraints
    ])
    
    NSLayoutConstraint.activate([
      noteTextField.topAnchor.constraint(equalTo: subsidieOverview.bottomAnchor, constant: 21),
      noteTextField.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 10),
      noteTextField.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -10),
      noteTextField.heightAnchor.constraint(equalToConstant: 53)
    ])
  }
}

extension MPaymentActionViewController {
  // MARK: - Actions
  @objc func showConfirm() {
    let view = ConfirmPayAction(frame: .zero)
    view.subsidie = subsidie
    view.organization = organization
    view.address = address
    view.vc = self
    view.setupView()
    view.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(view)
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: self.view.topAnchor),
      view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
    ])
    
    view.cancelButton.actionHandleBlock = {(_) in
      view.removeFromSuperview()
    }
  }
}
