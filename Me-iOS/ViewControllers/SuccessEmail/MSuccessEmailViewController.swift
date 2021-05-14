//
//  MSuccessEmailViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MSuccessEmailViewController: UIViewController {
    
    
    var email: String
    
    lazy var successEmailViewModel: SuccessEmailViewModel = {
        return SuccessEmailViewModel()
    }()
    
    // MARK: - Parameters
    
    var backButton: BackButton_DarkMode = {
        let button = BackButton_DarkMode(frame: .zero)
        return button
    }()
    
    var titleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansMedium(size: 36)
        label.text = Localize.email_has_been_sent()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var iconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = #imageLiteral(resourceName: "illustration")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var openMailButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(Localize.open_mail_app(), for: .normal)
        button.backgroundColor = Color.onTintSwitch
        button.rounded(cornerRadius: 9)
        button.titleLabel?.font = R.font.googleSansBold(size: 14)
        button.setupShadow(offset: CGSize(width: 0, height: 10), radius: 10, opacity: 0.2, color: UIColor.black.cgColor)
        return button
    }()
    
    var showQRCodeButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.backgroundColor = .white
        button.setTitleColor(Color.titleTextField, for: .normal)
        button.setTitle(Localize.pairing(), for: .normal)
        button.rounded(cornerRadius: 9)
        button.titleLabel?.font = R.font.googleSansBold(size: 14)
        button.setupShadow(offset: CGSize(width: 0, height: 10), radius: 10, opacity: 0.2, color: UIColor.black.cgColor)
        return button
    }()
    
    var textLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansRegular(size: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    
    // MARK: - Init
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
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(logIn), name: NotificationName.LoginQR, object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(authorizeToken(notifcation:)),
            name: NotificationName.AuthorizeTokenEmail,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(authorizeRegistrationToken(notifcation:)),
            name: NotificationName.AuthorizeRegistrationTokenEmail,
            object: nil)
    }
    
    private func setupView() {
        if #available(iOS 11.0, *) {
            self.view.backgroundColor = UIColor(named: "Background_DarkTheme")
        } else {
        }
        setupAccessibility()
        addObservers()
        setupActions()
        let mainString = String(format: Localize.click_on_link_you_received_continue(email))
        let range = (mainString as NSString).range(of: email)
        
        let attributedString = NSMutableAttributedString(string:mainString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.2078431373, green: 0.3921568627, blue: 0.9764705882, alpha: 1) , range: range)
        
        textLabel.attributedText = attributedString
    }
    
    @objc func authorizeToken(notifcation: Notification){
        
        successEmailViewModel.complete = { [weak self] (token) in
            DispatchQueue.main.async {
                self?.saveNewIdentity(accessToken: token)
                UserDefaults.standard.set(token, forKey: UserDefaultsName.Token)
                UserDefaults.standard.set(true, forKey: UserDefaultsName.UserIsLoged)
                CurrentSession.shared.token = token
                self?.addShortcuts(application: UIApplication.shared)
                UserDefaults.standard.synchronize()
                self?.performSegue(withIdentifier: "goToSuccessRegister", sender: self)
            }
        }
        
        if let token = notifcation.userInfo?["authToken"] as? String {
            successEmailViewModel.initCheckAuthorize(token: token)
        }
    }
    
    @objc func authorizeRegistrationToken(notifcation: Notification){
        
        successEmailViewModel.completeRegistration = { [weak self] (token) in
            DispatchQueue.main.async {
                self?.saveNewIdentity(accessToken: token)
                UserDefaults.standard.set(token, forKey: UserDefaultsName.Token)
                UserDefaults.standard.set(true, forKey: UserDefaultsName.UserIsLoged)
                CurrentSession.shared.token = token
                self?.addShortcuts(application: UIApplication.shared)
                UserDefaults.standard.synchronize()
                self?.performSegue(withIdentifier: "goToSuccessRegister", sender: self)
            }
        }
        
        if let token = notifcation.userInfo?["authToken"] as? String {
            successEmailViewModel.initSignUp(token: token)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func logIn(){
        let registerVC = MSuccessRegisterViewController()
        self.navigationController?.show(registerVC, sender: nil)
    }
}

extension MSuccessEmailViewController {
    // MARK: - Add Subviews
    private func addSubviews() {
        let views  = [backButton, titleLabel, iconView, openMailButton, showQRCodeButton, textLabel]
        views.forEach { view in
            self.view.addSubview(view)
        }
    }
}

extension MSuccessEmailViewController {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.left.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.view).offset(17)
            make.right.equalTo(self.view).offset(-17)
            make.height.equalTo(97)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(40)
        }
        
        iconView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalTo(self.view)
        }
        
        textLabel.snp.makeConstraints { make in
            make.left.equalTo(self.view).offset(21)
            make.right.equalTo(self.view).offset(-21)
            make.top.equalTo(iconView.snp.bottom).offset(8)
            make.height.equalTo(72)
        }
        
        openMailButton.snp.makeConstraints { make in
            make.height.equalTo(51)
            make.left.equalTo(self.view).offset(33)
            make.right.equalTo(self.view).offset(-33)
            make.top.equalTo(textLabel.snp.bottom).offset(22)
        }
        
        showQRCodeButton.snp.makeConstraints { make in
            make.height.equalTo(51)
            make.left.equalTo(self.view).offset(33)
            make.right.equalTo(self.view).offset(-33)
            make.top.equalTo(openMailButton.snp.bottom).offset(22)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-30)
        }
    }
}

extension MSuccessEmailViewController {
    // MARK: - Setup Actions
    private func setupActions() {
        
        backButton.actionHandleBlock = { [weak self] (button) in
            self?.back(button)
        }
        
        openMailButton.actionHandleBlock = { [weak self] (button) in
            self?.openMailApp()
        }
        
        showQRCodeButton.actionHandleBlock = { [weak self] (_) in
            let popOverVC = BottomQrWithPinViewController(nibName: "BottomQrWithPinViewController", bundle: nil)
            self?.showPopUPWithAnimation(vc: popOverVC)
        }
    }
    
    private func openMailApp() {
        if let mailURL = NSURL(string: "message://") {
            if UIApplication.shared.canOpenURL(mailURL as URL) {
                UIApplication.shared.open(mailURL as URL, options: [:],
                                          completionHandler: {
                                            (success) in })
                
            }else {
                self.showSimpleAlert(title: "Email App Missing", message: "You don't have email app on your device.")
            }
        }
    }
}

// MARK: - Accessibility Protocol

extension MSuccessEmailViewController: AccessibilityProtocol {
    func setupAccessibility() {
        openMailButton.setupAccesibility(description: "Open Mail App to confirm registration", accessibilityTraits: .button)
        showQRCodeButton.setupAccesibility(description: "Show Qr Code and Pin Code", accessibilityTraits: .button)
        titleLabel.setupAccesibility(description: Localize.bevestig_uw_emailadres(), accessibilityTraits: .header)
    }
}
