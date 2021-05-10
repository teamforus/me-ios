//
//  MAFirstPageViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 8/27/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

enum EnvironmentType: Int, CaseIterable {
    case production = 0
    case alpha = 1
    case demo = 2
    case dev = 3
    case custom = 4
}

enum EnvironmentTitles: String, CaseIterable {
    case production = "Production"
    case alpha = "Staging"
    case demo = "Demo"
    case dev = "Develop"
    case custom = "Custom"
}

import UIKit
import SkyFloatingLabelTextField
import IQKeyboardManagerSwift
import SnapKit

class MAFirstPageViewController: UIViewController {
    
    lazy var emailLoginViewModel: EmailLoginViewModel = {
        return EmailLoginViewModel()
    }()
    
    lazy var registerViewModel: RegisterViewModel = {
        return RegisterViewModel()
    }()
    
    // MARK: - Properties
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        return scrollView
    }()
    
    private var environmnetsStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 6
        stackView.isHidden = true
        return stackView
    }()
    
    private var chooseEnvironmentButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.setTitle("Choose Environmnet", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    private var emailField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField(frame: .zero)
        textField.font = R.font.googleSansRegular(size: 13)
        textField.textColor = .black
        textField.selectedLineColor = .black
        textField.lineColor = .lightGray
        textField.placeholderColor = Color.placeHolderTextField
        textField.placeholder = Localize.email()
        textField.titleColor = Color.titleTextField
        textField.selectedLineColor = Color.selectedTitleTextField
        textField.addTarget(self, action: #selector(didCheckValidateEmail(_:)), for: .editingChanged)
        return textField
    }()
    
    private var logoImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = #imageLiteral(resourceName: "logo_icon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var validationImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = #imageLiteral(resourceName: "proper")
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var confirmButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.setTitle(Localize.sign_in(), for: .normal)
        button.rounded(cornerRadius: 9)
        button.isEnabled = false
        button.titleLabel?.font = R.font.googleSansBold(size: 14)
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.2
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        return button
    }()
    
    private var showQRCodeButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.backgroundColor = .white
        button.setTitleColor(Color.titleTextField, for: .normal)
        button.setTitle(Localize.pairing(), for: .normal)
        button.rounded(cornerRadius: 9)
        button.titleLabel?.font = R.font.googleSansBold(size: 14)
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        return button
    }()
    
    private var welcomeLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.text = Localize.welcome_to_me()
        label.font = R.font.googleSansBold(size: 36)
        label.textAlignment = .center
        return label
    }()
    
    private var descriptionLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.text = Localize.log_from_another_device()
        label.font = R.font.googleSansRegular(size: 13)
        label.textAlignment = .center
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        setupUI()
    }
    
    private func setupUI() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        setupActions()
        setupAccessibility()
        setupEnvironments()
        setupEnvironmentButtons()
    }
    
    private func setupEnvironments() {
        #if DEV
        chooseEnvironmentButton.isHidden = false
        if UserDefaults.standard.string(forKey: UserDefaultsName.EnvironmentURL) == nil{
            
            CheckWebSiteReacheble.checkWebsite(url: "https://develop.test.api.forus.io") { (isReacheble) in
                if isReacheble { UserDefaults.standard.setValue("https://develop.test.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentURL)
                }else {
                    UserDefaults.standard.setValue("https://dev.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentURL)
                }
            }
            
            chooseEnvironmentButton.setTitle("Dev", for: .normal)
            UserDefaults.standard.setValue("Dev", forKey: UserDefaultsName.EnvironmentName)
        }else {
            
            chooseEnvironmentButton.setTitle(UserDefaults.standard.string(forKey: UserDefaultsName.EnvironmentName), for: .normal)
        }
        #endif
    }
    
    private func setupInitialEmailFieldState() {
        if self.traitCollection.userInterfaceStyle == .dark {
            emailField.textColor = .white
            emailField.selectedLineColor = .white
        } else {
            emailField.textColor = .black
            emailField.selectedLineColor = .black
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupInitialEmailFieldState()
        NotificationCenter.default.addObserver(self, selector: #selector(logIn), name: NotificationName.LoginQR, object: nil)
    }
    
    private func setupEnvironmentButtons() {
        for i in 0..<EnvironmentType.allCases.count {
            let button = ActionButton(frame: .zero)
            button.tag = i
            button.setTitle(EnvironmentTitles.allCases[i].rawValue, for: .normal)
            button.setTitleColor(.blue, for: .normal)
            environmnetsStackView.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(100)
            }
            button.actionHandleBlock = { [weak self] (button) in
                self?.didChooseEnvironment(environmentType: EnvironmentType.allCases[button.tag])
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupInitialEmailFieldState()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        setupInitialEmailFieldState()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NotificationName.LoginQR, object: nil)
    }
    
    
    @objc func logIn(){
        performSegue(withIdentifier: "goToSuccessRegister", sender: self)
    }
    
    @objc func didCheckValidateEmail(_ sender: SkyFloatingLabelTextField) {
        if validateEmail(emailField.text!){
            validationImage.isHidden = false
            confirmButton.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.3921568627, blue: 0.9764705882, alpha: 1)
            confirmButton.isEnabled = true
        }else{
            validationImage.isHidden = true
            confirmButton.backgroundColor = #colorLiteral(red: 0.7647058824, green: 0.7647058824, blue: 0.7647058824, alpha: 1)
            confirmButton.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSuccessMail" {
            let vc = segue.destination as! MSuccessEmailViewController
            vc.email = emailField.text ?? ""
        }
    }
}

extension MAFirstPageViewController {
    // MARK: - Add Subviews
    private func addSubviews() {
        self.view.addSubview(scrollView)
        let views = [environmnetsStackView, chooseEnvironmentButton, emailField, logoImage, validationImage, confirmButton, showQRCodeButton, welcomeLabel, descriptionLabel]
        views.forEach { view in
            scrollView.addSubview(view)
        }
    }
}

extension MAFirstPageViewController {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self.view)
        }
        
        chooseEnvironmentButton.snp.makeConstraints { make in
            make.left.equalTo(self.view).offset(32)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        environmnetsStackView.snp.makeConstraints { make in
            make.left.equalTo(self.view).offset(27)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(50)
        }
        
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(164)
            make.centerX.equalTo(scrollView)
            make.width.equalTo(100)
            make.height.equalTo(85)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(25)
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
            make.height.equalTo(50)
        }
        
        emailField.snp.makeConstraints { make in
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
            make.height.equalTo(62)
            make.top.equalTo(welcomeLabel.snp.bottom).offset(33)
        }
        
        validationImage.snp.makeConstraints { make in
            make.width.height.equalTo(14)
            make.top.equalTo(welcomeLabel.snp.bottom).offset(63)
            make.right.equalTo(self.view).offset(-30)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(24)
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
            make.height.equalTo(51)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmButton.snp.bottom).offset(56)
            make.left.equalTo(self.view).offset(62)
            make.height.equalTo(20)
            make.right.equalTo(self.view).offset(-62)
        }
        
        showQRCodeButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(13)
            make.left.equalTo(self.view).offset(30)
            make.height.equalTo(51)
            make.right.equalTo(self.view).offset(-30)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-30)
        }
    }
}

extension MAFirstPageViewController {
    private func setupActions() {
        
        chooseEnvironmentButton.actionHandleBlock = { [weak self] (_) in
            guard let self = self else {
                return
            }
            self.environmnetsStackView.isHidden = !self.environmnetsStackView.isHidden
        }
        
        confirmButton.actionHandleBlock = { [weak self] (_) in
            self?.didLogIn()
        }
        
        showQRCodeButton.actionHandleBlock = { [weak self] (_) in
            let popOverVC = BottomQrWithPinViewController(nibName: "BottomQrWithPinViewController", bundle: nil)
            self?.showPopUPWithAnimation(vc: popOverVC)
        }
    }
    
    private func didLogIn() {
        if isReachable() {
            
            registerViewModel.initRegister(identity: Identity(email: emailField.text ?? ""))
        }else {
            
            showInternetUnable()
            
        }
        
        registerViewModel.complete = { [weak self] (response, statusCode) in
            
            DispatchQueue.main.async {
                if statusCode == 422 {
                    
                    self?.emailLoginViewModel.initLoginByEmail(email: self?.emailField.text ?? "")
                    
                }else if statusCode == 500 {
                    self?.showSimpleAlertWithSingleAction(title: Localize.error_exclamation(), message: "", okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
                    }))
                }else {
                    self?.performSegue(withIdentifier: "goToSuccessMail", sender: nil)
                }
            }
        }
        
        emailLoginViewModel.complete = { [weak self] (message, statusCode) in
            
            DispatchQueue.main.async {
                
                if statusCode != 500 {
                    
                    self?.performSegue(withIdentifier: "goToSuccessMail", sender: self)
                    
                }else {
                    self?.showSimpleAlertWithSingleAction(title: Localize.error_exclamation(), message: "", okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
                    }))
                }
            }
        }
    }
    
    private func didChooseEnvironment(environmentType: EnvironmentType) {
        environmnetsStackView.isHidden = true
        switch environmentType {
        case .production:
            UserDefaults.standard.setValue("https://api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentURL)
            UserDefaults.standard.setValue("Production", forKey: UserDefaultsName.EnvironmentName)
            chooseEnvironmentButton.setTitle("Production", for: .normal)
        case .alpha:
            
            UserDefaults.standard.setValue("https://staging.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentURL)
            UserDefaults.standard.setValue("Alpha", forKey: UserDefaultsName.EnvironmentName)
            chooseEnvironmentButton.setTitle("Alpha", for: .normal)
        case .demo:
            UserDefaults.standard.setValue("https://demo.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentURL)
            UserDefaults.standard.setValue("Demo", forKey: UserDefaultsName.EnvironmentName)
            chooseEnvironmentButton.setTitle("Demo", for: .normal)
        case .dev:
            UserDefaults.standard.setValue("https://dev.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentURL)
            UserDefaults.standard.setValue("Dev", forKey: UserDefaultsName.EnvironmentName)
            chooseEnvironmentButton.setTitle("Dev", for: .normal)
            break
            
        case .custom:
            let alertController = UIAlertController(title: "Add custom URL", message: "", preferredStyle: .alert)
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter Base URL"
                if self.chooseEnvironmentButton.titleLabel?.text == "Custom" {
                    textField.text = UserDefaults.standard.string(forKey: UserDefaultsName.EnvironmentURL)
                }
            }
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
                let firstTextField = alertController.textFields![0] as UITextField
                UserDefaults.standard.setValue(firstTextField.text ?? "", forKey: UserDefaultsName.EnvironmentURL)
                UserDefaults.standard.setValue("Custom", forKey: UserDefaultsName.EnvironmentName)
                self.chooseEnvironmentButton.setTitle("Custom", for: .normal)
            })
            let cancelAction = UIAlertAction(title: Localize.cancel(), style: .cancel, handler: { (action : UIAlertAction!) -> Void in })
            
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - Accessibility Protocol

extension MAFirstPageViewController: AccessibilityProtocol {
    func setupAccessibility() {
        emailField.setupAccesibility(description: "Enter your email", accessibilityTraits: .none)
        confirmButton.setupAccesibility(description: Localize.confirm(), accessibilityTraits: .button)
        showQRCodeButton.setupAccesibility(description: "Show Qr Code and Pin Code", accessibilityTraits: .button)
        validationImage.setupAccesibility(description: "Email is valid", accessibilityTraits: .image)
        welcomeLabel.setupAccesibility(description: Localize.welcome_to_me(), accessibilityTraits: .header)
    }
}
