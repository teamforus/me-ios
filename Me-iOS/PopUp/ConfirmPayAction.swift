//
//  ConfirmPayAction.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 04.09.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class ConfirmPayAction: UIView {
    
    var subsidie: Subsidie?
    var organization: AllowedOrganization?
    var address: String!
    
    var commonService: CommonServiceProtocol! = CommonService()
    var vc: UIViewController!
    
    // MARK: - Parameters
    private let blurView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        view.alpha = 0.3
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
        label.font = UIFont(name: "GoogleSans-Medium", size: 24)
        label.text = Localize.confirm_transaction()
        return label
    }()
    
    private let priceLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let cancelButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.setTitle(Localize.cancel(), for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1702004969, green: 0.3387943804, blue: 1, alpha: 1), for: .normal)
        return button
    }()
    
    private let confirmButton: ShadowButton = {
        let button = ShadowButton(frame: .zero)
        button.setTitle(Localize.confirm(), for: .normal)
        button.cornerRadius = 6
        button.backgroundColor = #colorLiteral(red: 0.1702004969, green: 0.3387943804, blue: 1, alpha: 1)
        button.addTarget(self, action: #selector(confirmPay), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        addBodySubviews()
        setupBodyConstraints()
    }
    
    func setupView() {
        if subsidie?.price_type == SubsidieType.regular.rawValue{
            priceLabel.font = UIFont(name: "GoogleSans-Regular", size: 16)
            let finalPrice = subsidie?.price == subsidie?.sponsor_subsidy ? Localize.free() : subsidie?.price_user
            var mainString = ""
            var range = NSRange()
            if finalPrice == Localize.free() {
                mainString = String(format: "Prijs\n" + Localize.free())
                range = (mainString as NSString).range(of: Localize.free())
            }else {
                mainString = String(format: "Heeft de klant\n" + "€ " + subsidie!.price_user!.showDeciaml() + "\nbetaald aan de kassa?")
                range = (mainString as NSString).range(of: "€ " + subsidie!.price_user!.showDeciaml())
            }
            
            let attributedString = NSMutableAttributedString(string:mainString)
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "GoogleSans-Regular", size: 40)! , range: range)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.1702004969, green: 0.3387943804, blue: 1, alpha: 1).cgColor, range: range)
            priceLabel.attributedText = attributedString
        }else if subsidie?.price_type == SubsidieType.free.rawValue {
            priceLabel.font = UIFont(name: "GoogleSans-Regular", size: 16)
            let mainString = String(format: "Prijs\n" + Localize.free())
            let range = (mainString as NSString).range(of: Localize.free())
            let attributedString = NSMutableAttributedString(string:mainString)
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "GoogleSans-Regular", size: 40)! , range: range)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.1702004969, green: 0.3387943804, blue: 1, alpha: 1).cgColor, range: range)
            priceLabel.attributedText = attributedString
        }else if subsidie?.price_type == SubsidieType.discountFixed.rawValue {
            priceLabel.font = UIFont(name: "GoogleSans-Regular", size: 16)
            let mainString = String(format: "Korting\n" + "€ " + (subsidie!.price_discount?.showDeciaml())!)
            let range = (mainString as NSString).range(of: "€ " + (subsidie!.price_discount?.showDeciaml())!)
            let attributedString = NSMutableAttributedString(string:mainString)
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "GoogleSans-Regular", size: 40)! , range: range)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.1702004969, green: 0.3387943804, blue: 1, alpha: 1).cgColor, range: range)
            priceLabel.attributedText = attributedString
        }else if subsidie?.price_type == SubsidieType.discountPercentage.rawValue {
            priceLabel.font = UIFont(name: "GoogleSans-Regular", size: 16)
            let priceDiscount = Int(subsidie?.price_discount?.double ?? 0.0)
            let mainString = String(format: "Korting\n \(priceDiscount)﹪")
            let range = (mainString as NSString).range(of: "\(priceDiscount)﹪")
            let attributedString = NSMutableAttributedString(string:mainString)
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "GoogleSans-Regular", size: 40)! , range: range)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.1702004969, green: 0.3387943804, blue: 1, alpha: 1).cgColor, range: range)
            priceLabel.attributedText = attributedString
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

// MARK: - Add Subviews

extension ConfirmPayAction {
    
    func addSubviews() {
        let views = [blurView, bodyView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
    }
    
    func addBodySubviews() {
        let views = [titleLabel, priceLabel, cancelButton, confirmButton]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.bodyView.addSubview(view)
        }
    }
}

// MARK: - Add Constraints

extension ConfirmPayAction {
    
    func setupConstraints() {
        blurView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self)
        }
        
        bodyView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.height.equalTo(250)
            make.left.equalTo(38)
            make.right.equalTo(-38)
        }
    }
    
    func setupBodyConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyView).offset(26)
            make.left.equalTo(bodyView).offset(52)
            make.right.equalTo(bodyView).offset(-52)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.left.right.equalTo(bodyView)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalTo(bodyView).offset(-19)
            make.left.equalTo(bodyView).offset(19)
            make.height.equalTo(46)
            make.width.equalTo(128)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalTo(bodyView).offset(-19)
            make.right.equalTo(bodyView).offset(-19)
            make.left.equalTo(cancelButton.snp.right).offset(6)
            make.height.equalTo(46)
        }
    }
}

// MARK: - Request

extension ConfirmPayAction {
    @objc func confirmPay() {
        KVSpinnerView.show()
        let data = SubsidiePay(organization_id: organization?.id ?? 0, product_id: subsidie?.id ?? 0)
        commonService.create(request: "platform/provider/vouchers/" + address! + "/transactions", data: data) { (response: ResponseData<Transaction>, statusCode) in
            
            DispatchQueue.main.async {
                KVSpinnerView.dismiss()
                if statusCode == 201 {
                    
                    self.vc.showSimpleAlertWithSingleAction(title: Localize.success(), message: Localize.payment_succeeded(), okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
                        
                        self.vc.presentingViewController?.presentingViewController?.dismiss(animated: true)
                    }))
                }else if statusCode == 401 {
                    DispatchQueue.main.async {
                        KVSpinnerView.dismiss()
                        self.vc.showSimpleAlertWithSingleAction(title: Localize.expired_session(), message: Localize.your_session_has_expired() , okAction: UIAlertAction(title: Localize.log_out(), style: .default, handler: { (action) in
                            self.vc.logoutOptions()
                        }))
                    }
                }else {
                    self.vc.showSimpleAlertWithSingleAction(title: Localize.warning(), message: Localize.voucher_not_have_enough_funds(), okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
                    }))
                }
            }
        }
    }
}
