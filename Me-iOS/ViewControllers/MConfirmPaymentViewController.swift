//
//  MConfirmPaymentViewController.swift
//  Me-iOS
//
//  Created by Daniel Tcacenco on 30.10.2024.
//  Copyright © 2024 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SnapKit

class MConfirmPaymentViewController: UIViewController {
    
    var voucher: Voucher!
    var voucherToken: Transaction!
    var testToken: String!
    var amount: String!
    var tabBar: UITabBarController!
    var organizationId: Int!
    var note: String!
    var commonService: CommonServiceProtocol! = CommonService()
    
    private var keyboard = KeyboardDismissHandler()
    
    var amountText: String = ""
    
    var isColapsed: Bool = false{
        didSet {
            
            moreInfoIcon.image = isColapsed ? Image.collapseOnIcon : Image.collapseOffIcon
            self.view.layoutIfNeeded()
        }
    }
    
    var originalFrame: CGRect = .zero
    
    private let bodyView: Background_DarkMode = {
        let view = Background_DarkMode()
        view.colorName = "WhiteBackground_DarkTheme"
        view.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 16)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GoogleSans-Regular", size: 24)
        label.textColor = .black
        label.text = Localize.attention()
        return label
    }()
    
    private let warningIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = Image.errorIcon
        return imageView
    }()
    
    private let closeButton: ActionButton = {
        let button = ActionButton()
        button.setImage(#imageLiteral(resourceName: "closeIcon"), for: .normal)
//        button.addTarget(self, action: #selector(popOut), for: .touchUpInside)
        return button
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.layer.borderColor = UIColor.init(hex: "#F4F4F4").cgColor
        view.layer.borderWidth = 1.0
        view.rounded(cornerRadius: 16)
        view.axis = .vertical
        view.distribution = .fill
        
        return view
    }()
    
    private let priceInfoView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(hex: "#FDF5E6")
        return view
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Regular", size: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = Localize.reques_extra_payment_info()
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Bold", size: 18)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "€0,00"
        return label
    }()
    
    private let moreInfoButtonView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private let moreInfoTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = Localize.more_information()
        label.font = UIFont(name: "GoogleSans-Medium", size: 14)
        label.textColor = Color.blueText
        return label
    }()
    
    private let moreInfoIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = Image.collapseOffIcon
        return imageView
    }()
    
    private let moreInfoButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        return button
    }()
    
    private let separatorInfoView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.init(hex: "#F4F4F4")
        return view
    }()
    
    private let moreInfoViewInfoView: UIView = {
        let view = UIView(frame: .zero)
        view.isHidden = true
        return view
    }()
    
    private let moreInfoLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Regular", size: 13)
        label.text = Localize.more_information_description()
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
     
    private let separatorView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.init(hex: "#F4F4F4")
        return view
    }()
    
    lazy var stackViewButton: UIStackView = {
       let view = UIStackView(arrangedSubviews: [cancelButton, doneButton])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 15
        return view
    }()
    
    
    private let cancelButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.setTitle(Localize.decline(), for: .normal)
        button.setTitleColor(Color.blueText, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    private let doneButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.setTitle(Localize.submit(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Color.blueText
        button.rounded(cornerRadius: 6)
        return button
    }()
    
    private let customFields: CustomTextField = {
        let textField = CustomTextField(frame: .zero)
        textField.setup(title: Localize.info_amount_extra_field(),
                        placeHolder: "€ 0,00",
                        icon: nil,
                        type: .numberPad)
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    deinit {
        keyboard.removeObservers()
        print("deinit Panel C")
    }
    // MARK: - Setup View
    private func setupView() {
        addSubviews()
        setupConstraints()
        keyboard.addObservers()
        priceLabel.text = "€ \(Double(amount ?? "") ?? 0)"
        keyboard.onChangedKeyboardHeight = { [weak self] height in
            guard let strongSelf = self else { return }
            
            if height != 0 {
//                strongSelf.view.frame.size.height = height
                strongSelf.view.frame.origin.y = height - (strongSelf.originalFrame.size.height / 1.5)
            }else {
                strongSelf.view.frame = strongSelf.originalFrame
            }
           
            strongSelf.view.layoutIfNeeded()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.originalFrame = self.view.frame
        })
        
        customFields.textHandleBlock = { [weak self] (customField) in
            guard let strongSelf = self else { return }
            
            strongSelf.amountText = customField.text ?? ""
        }
        
        closeButton.actionHandleBlock = { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true)
        }
        
        cancelButton.actionHandleBlock = { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true)
        }
        
        doneButton.actionHandleBlock = { [weak self] (sender) in
            guard let strongSelf = self else { return }
            
            let amount = strongSelf.amount.replacingOccurrences(of: ",", with: ".")
            let textFieldAmount = strongSelf.amountText.replacingOccurrences(of: ",", with: ".")
            
            if Double(amount) ?? 0 > Double(textFieldAmount) ?? 0{
                strongSelf.customFields.setError(with: Localize.info_error_amount_extra_field())
                return
            }
            
            let extraAmount = (Double(textFieldAmount) ?? 0) - (Double(strongSelf.voucher.amount ?? "0") ?? 0)
            
            let extraCash = "\(extraAmount)"
            
            let payTransaction = PayTransaction(organization_id: strongSelf.organizationId ?? 0, amount: strongSelf.voucher.amount?.replacingOccurrences(of: ",", with: "."), amount_extra_cash: extraCash.replacingOccurrences(of: ",", with: "."), note: strongSelf.note ?? "")
            
            strongSelf.commonService.create(request: "platform/vouchers/"+strongSelf.voucher.address!+"/transactions", data: payTransaction) { (response: ResponseData<Transaction>, statusCode) in
                
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    if statusCode == 201 {
                        
                        strongSelf.showSimpleAlertWithSingleAction(title: Localize.success(), message: Localize.payment_succeeded(), okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
                            
                            HomeTabViewController.shared.setTab(.voucher)
                            
                            strongSelf.presentingViewController?.presentingViewController?.dismiss(animated: true)
                        }))
                    }else if statusCode == 401 {
                        DispatchQueue.main.async {
                            KVSpinnerView.dismiss()
                            strongSelf.showSimpleAlertWithSingleAction(title: Localize.expired_session() , message: Localize.your_session_has_expired() , okAction: UIAlertAction(title: Localize.log_out(), style: .default, handler: { (action) in
                                strongSelf.logoutOptions()
                            }))
                        }
                    }else {
                        sender.isEnabled = true
                        strongSelf.showSimpleAlertWithSingleAction(title: Localize.warning(), message: Localize.voucher_not_have_enough_funds(), okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
                            
                            
                        }))
                    }
                }
            }
        }
        
        moreInfoButton.actionHandleBlock = { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.isColapsed = !strongSelf.isColapsed
            if !strongSelf.isColapsed {
                UIView.animate(withDuration: 0.3) {
                    strongSelf.moreInfoViewInfoView.isHidden = true
                    strongSelf.view.frame = strongSelf.originalFrame
                    strongSelf.view.layoutIfNeeded()
                }
                return
            }
            let height = strongSelf.isColapsed ? strongSelf.originalFrame.size.height + 110 : strongSelf.originalFrame.size.height
            var origin = strongSelf.originalFrame
            
            UIView.animate(withDuration: 0.3) {
                let adjustedHeight = height + strongSelf.view.safeAreaInsets.bottom
                let targetSize = CGSize(width: strongSelf.originalFrame.width,
                                        height: adjustedHeight)
                let targetOrigin = CGPoint(x: 0, y: strongSelf.originalFrame.maxY - targetSize.height)
                origin = CGRect(origin: targetOrigin, size: targetSize)
                strongSelf.view.frame = origin
                strongSelf.moreInfoViewInfoView.isHidden = !strongSelf.isColapsed
                strongSelf.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - Add Subview
extension MConfirmPaymentViewController {
    private func addSubviews(){
        self.view.addSubview(bodyView)
        let views = [warningIcon,
                     titleLabel,
                     closeButton,
                     stackView,
                     customFields,
                     separatorView,
                     stackViewButton]
        
        views.forEach { view in
            self.bodyView.addSubview(view)
        }
        
        let stackViews = [priceInfoView,
                          moreInfoButtonView,
                          moreInfoViewInfoView]
        
        let priceViews = [infoLabel,
                          priceLabel]
        
        moreInfoViewInfoView.addSubview(moreInfoLabel)
        
        let moreInfoButtonViews = [moreInfoTitle,
                                   moreInfoIcon,
                                   separatorInfoView,
                                   moreInfoButton]
        
        moreInfoButtonViews.forEach { view in
            self.moreInfoButtonView.addSubview(view)
        }
        
        priceViews.forEach { view in
            self.priceInfoView.addSubview(view)
        }
        
        stackViews.forEach { view in
            self.stackView.addArrangedSubview(view)
        }
    }
}
// MARK: - Setup Constraints
extension MConfirmPaymentViewController {
    private func setupConstraints(){
        bodyView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.top.right.equalToSuperview().inset(20)
        }
        
        warningIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(58)
            make.top.equalToSuperview().offset(31)
        }
        
        moreInfoButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(warningIcon.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(22)
        }
        
        customFields.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(110)
            make.top.equalTo(stackView.snp.bottom).offset(30)
        }
        
        separatorView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(customFields.snp.bottom).offset(30)
        }
        
        stackViewButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(separatorView.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(46)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
        
        moreInfoLabel.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview().inset(20)
        }
        
        moreInfoIcon.snp.makeConstraints { make in
            make.height.width.equalTo(12)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
        
        moreInfoTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        
        separatorInfoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
        moreInfoButton.snp.makeConstraints { make in
            make.right.top.left.bottom.equalToSuperview()
        }
    }
}
