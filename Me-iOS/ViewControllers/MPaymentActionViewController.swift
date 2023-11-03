//
//  MPaymentActionViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 04.09.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

struct PaymenyActionModel {
    var subsidie: Subsidie?
    var fund: Fund?
    var organization: AllowedOrganization?
    var voucherAddress: String
}

class MPaymentActionViewController: UIViewController {
    
    var paymentAction: PaymenyActionModel
    var navigator: Navigator
    var subsidieOverviewHeightConstraints: NSLayoutConstraint!
    
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
    
    
    // MARK: - Setup View
    
    init(navigator: Navigator, paymentAction: PaymenyActionModel) {
        self.navigator = navigator
        self.paymentAction = paymentAction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setupConstraints()
        setupView()
    }
    
    func setupView() {
        if let subsidie = self.paymentAction.subsidie {
            setupActions(subsidie: subsidie)
        }
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:))))
        
        if #available(iOS 11.0, *) {
            noteTextField.backgroundColor = R.color.grayWithLight_Dark_DarkTheme()
        } else {
            // Fallback on earlier versions
        }
        if let subsidie = paymentAction.subsidie {
            subsidieOverview.configureSubsidie(subsidie: subsidie, and: self)
        }
        addObservers()
        noteTextField.delegate = self
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
        scrollView.addSubview(bodyView)
        addBodySubviews()
        addSubsidieSubviews()
        addMiddleSubviews()
    }
    
    func addBodySubviews() {
        let views = [backButton, titleLabel, subsidieView, middleView, payButton]
        views.forEach { (view) in
            bodyView.addSubview(view)
        }
    }
    
    func addSubsidieSubviews() {
        let views = [subsidieNameLabel, subsidieImageView]
        views.forEach { (view) in
            subsidieView.addSubview(view)
        }
    }
    
    func addMiddleSubviews() {
        let views = [topLineView, lineView, subsidieOverview, noteTextField, bottomLine]
        views.forEach { (view) in
            middleView.addSubview(view)
        }
    }
}

// MARK: - Add Constraints

extension MPaymentActionViewController {
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.view)
        }
        
        
        bodyView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.scrollView)
            make.height.equalTo(self.scrollView)
            make.width.equalTo(self.view)
        }
        setupBodyConstraints()
        setupSubsidieConstraints()
        setupMiddleConstraints()
    }
    
    func setupBodyConstraints() {
        
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.left.equalTo(bodyView).offset(10)
            make.top.equalTo(bodyView).offset(35)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyView).offset(40)
            make.centerX.equalTo(bodyView)
            make.height.equalTo(20)
        }
        
        subsidieView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(21)
            make.left.equalTo(bodyView).offset(17)
            make.right.equalTo(bodyView).offset(-17)
            make.bottom.equalTo(middleView.snp.top).offset(-13)
            make.height.equalTo(86)
        }
        
        
        var bottomConstant = -100
        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE ||  UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            bottomConstant = -10
        }
        
        middleView.snp.makeConstraints { make  in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(bodyView).offset(bottomConstant)
        }
        
        payButton.snp.makeConstraints { make in
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.bottom.equalTo(self.view).offset(-30)
            make.height.equalTo(46)
        }
    }
    
    func setupSubsidieConstraints() {
        
        subsidieNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(subsidieView)
            make.left.equalTo(subsidieView).offset(20)
        }
        
        subsidieImageView.snp.makeConstraints { make in
            make.centerY.equalTo(subsidieView)
            make.height.width.equalTo(50)
            make.left.equalTo(subsidieNameLabel.snp.right).offset(20)
            make.right.equalTo(subsidieView).offset(-20)
        }
    }
    
    func setupMiddleConstraints() {
        
        topLineView.snp.makeConstraints { make in
            make.left.top.right.equalTo(middleView)
            make.height.equalTo(1)
        }
        
        topLineView.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(middleView)
            make.height.equalTo(1)
        }
        
        topLineView.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(middleView)
            make.height.equalTo(1)
        }
        
        
        subsidieOverviewHeightConstraints = subsidieOverview.heightAnchor.constraint(equalToConstant: 330)
        NSLayoutConstraint.activate([
            subsidieOverview.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 22),
            subsidieOverview.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 10),
            subsidieOverview.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -10),
            subsidieOverviewHeightConstraints
        ])
        
        noteTextField.snp.makeConstraints { make in
            make.top.equalTo(subsidieOverview.snp.bottom).offset(21)
            make.left.equalTo(middleView).offset(10)
            make.right.equalTo(middleView).offset(-10)
            make.height.equalTo(53)
        }
    }
}

extension MPaymentActionViewController: UITextFieldDelegate {
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension MPaymentActionViewController {
    // MARK: - Actions
    @objc func showConfirm() {
        let view = ConfirmPayAction(paymentAction: paymentAction)
        view.vc = self
        view.setupView()
        self.view.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.view)
        }
        
        view.cancelButton.actionHandleBlock = {(_) in
            view.removeFromSuperview()
        }
    }
}
