//
//  SubsidieOverview.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 22.12.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

enum SubsidieType: String, CaseIterable {
    case free = "free"
    case regular = "regular"
    case discountPercentage = "discount_percentage"
    case discountFixed = "discount_fixed"
}

class SubsidieOverview: UIView {
    
    
    // MARK: - Properties
    let bodyView: Background_DarkMode = {
        let view = Background_DarkMode()
        view.colorName = "Gray_Dark_DarkTheme"
        view.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 16)
        return view
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = R.font.googleSansRegular(size: 30)
        label.text = "€ 0,00"
        label.textColor = #colorLiteral(red: 0.1903552711, green: 0.369412154, blue: 0.9929068685, alpha: 1)
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = R.font.googleSansRegular(size: 13)
        label.text = Localize.paid_by_customer()
        label.textColor = #colorLiteral(red: 0.1903552711, green: 0.369412154, blue: 0.9929068685, alpha: 1)
        return label
    }()
    
    private let detailView: Background_DarkMode = {
        let view = Background_DarkMode()
        view.colorName = "GrayWithLight_Dark_DarkTheme"
        view.corner = 16
        return view
    }()
    
    private let priceAgreementLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansBold(size: 18)
        label.text = Localize.transaction_details()
        return label
    }()
    
    private let totalPriceTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = Localize.total_price()
        label.font = R.font.googleSansRegular(size: 13)
        label.textColor = #colorLiteral(red: 0.5569542646, green: 0.5565612912, blue: 0.5783070922, alpha: 1)
        return label
    }()
    
    private let totalPrice: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansRegular(size: 15)
        label.text = "€ 0,00"
        return label
    }()
    
    private let sponsorName: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = R.font.googleSansRegular(size: 13)
        label.textColor = #colorLiteral(red: 0.5569542646, green: 0.5565612912, blue: 0.5783070922, alpha: 1)
        return label
    }()
    
    private let sponsorPrice: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansRegular(size: 15)
        label.text = "€ 0,00"
        return label
    }()
    
    private let finalPriceTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = R.font.googleSansRegular(size: 13)
        label.text = Localize.what_customer_pays()
        label.textColor = #colorLiteral(red: 0.5569542646, green: 0.5565612912, blue: 0.5783070922, alpha: 1)
        return label
    }()
    
    private let finalPrice: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = R.font.googleSansRegular(size: 15)
        label.text = "€ 0,00"
        label.textColor = #colorLiteral(red: 0.1903552711, green: 0.369412154, blue: 0.9929068685, alpha: 1)
        return label
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureSubsidie(subsidie: Subsidie, and vc: MPaymentActionViewController) {
        
        switch subsidie.price_type {
        case SubsidieType.regular.rawValue:
            self.showRegularState(subsidie: subsidie, vc: vc)
        case SubsidieType.free.rawValue:
            self.showFreeState(subsidie: subsidie, vc: vc)
        case SubsidieType.discountFixed.rawValue:
            self.showDiscontFixedState(subsidie: subsidie, vc: vc)
        case SubsidieType.discountPercentage.rawValue:
            self.showDiscountPercentageState(subsidie: subsidie, vc: vc)
        default:
            break
        }
    }
    
    func showRegularState(subsidie: Subsidie, vc: MPaymentActionViewController) {
        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE ||  UIDevice.current.screenType == .iPhones_6_6s_7_8 {
           
        }
        sponsorName.text = Localize.subsid_by(subsidie.sponsor?.name ?? "")
        totalPrice.text = "€ \(subsidie.price?.showDeciaml() ?? "")"
        self.sponsorPrice.text = "€ \(subsidie.sponsor_subsidy?.showDeciaml() ?? "")"
        
        let finalPrice = subsidie.price == subsidie.sponsor_subsidy ? Localize.free() : subsidie.price_user
        
        if ((finalPrice?.double) != nil) {
            self.priceLabel.text = String("€ \(finalPrice!.showDeciaml())").replacingOccurrences(of: ".", with: ",")
            self.finalPrice.text = String("€ \(finalPrice!.showDeciaml())").replacingOccurrences(of: ".", with: ",")
        }else {
            self.priceLabel.text = finalPrice
            self.finalPrice.text = finalPrice
        }
        
      
    }
    
    func showFreeState(subsidie: Subsidie, vc: MPaymentActionViewController) {
        self.infoLabel.isHidden = true
        self.priceLabel.text = Localize.free()
        
        bodyView.snp.updateConstraints { make in
            make.top.equalTo(self).offset(14)
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-16)
        }
        if (subsidie.sponsor_subsidy?.double)! > 0.00 {
            self.totalPriceTitle.text = Localize.subsid_by(subsidie.sponsor?.name ?? "")
            self.totalPrice.text = String("€ \(subsidie.sponsor_subsidy?.showDeciaml())").replacingOccurrences(of: ".", with: ",")
            vc.subsidieOverviewHeightConstraints.constant = 160
        }else {
            vc.subsidieOverviewHeightConstraints.constant = 110
        }
    }
    
    func showDiscontFixedState(subsidie: Subsidie, vc: MPaymentActionViewController) {
        self.totalPriceTitle.text = Localize.discount()
        self.totalPrice.text = String("€ \(subsidie.price_discount!.showDeciaml())").replacingOccurrences(of: ".", with: ",")
        if (subsidie.sponsor_subsidy?.double)! > 0.00 {
            self.sponsorName.text = Localize.subsid_by(subsidie.sponsor?.name ?? "")
            self.sponsorPrice.text = String("€ \(subsidie.sponsor_subsidy!.showDeciaml())").replacingOccurrences(of: ".", with: ",")
            vc.subsidieOverviewHeightConstraints.constant = 170
        }else {
            vc.subsidieOverviewHeightConstraints.constant = 130
        }
        bodyView.snp.updateConstraints { make in
            make.top.equalTo(self)
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-16)
        }
        
    }
    
    func showDiscountPercentageState(subsidie: Subsidie, vc: MPaymentActionViewController) {
        self.totalPriceTitle.text = Localize.discount()
        self.totalPrice.text = String("\(subsidie.price_discount!)%").replacingOccurrences(of: ".00", with: "")
        self.infoLabel.isHidden = true
        self.priceLabel.isHidden = true
        bodyView.snp.updateConstraints { make in
            make.top.equalTo(self)
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-16)
        }
        self.detailView.layoutIfNeeded()
        if (subsidie.sponsor_subsidy?.double)! > 0.00 {
            self.sponsorName.text = Localize.subsid_by(subsidie.sponsor?.name ?? "")
            self.sponsorPrice.text = String("€ \(subsidie.sponsor_subsidy!.showDeciaml())").replacingOccurrences(of: ".", with: ",")
            vc.subsidieOverviewHeightConstraints.constant = 170
        }else {
            vc.subsidieOverviewHeightConstraints.constant = 130
        }
    }
}

extension SubsidieOverview {
    // MARK: - Add Subviews
    
    private func addSubviews() {
        let views = [bodyView]
        views.forEach { (view) in
            addSubview(view)
        }
        addSubviewsBodyView()
        addDetailViewSubviews()
    }
    
    private func addSubviewsBodyView() {
        let views = [infoLabel, priceLabel, detailView]
        views.forEach { (view) in
            self.bodyView.addSubview(view)
        }
    }
    
    private func addDetailViewSubviews() {
        let views = [priceAgreementLabel, totalPriceTitle, totalPrice, sponsorName, sponsorPrice, finalPriceTitle, finalPrice]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.detailView.addSubview(view)
        }
    }
}

extension SubsidieOverview {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        
        bodyView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyView).offset(30)
            make.centerX.equalTo(bodyView)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(10)
            make.centerX.equalTo(bodyView)
        }
        
        detailView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(14)
            make.left.right.equalTo(bodyView)
            make.bottom.equalTo(bodyView).offset(-16)
        }
        
        
        priceAgreementLabel.snp.makeConstraints { make in
            make.top.equalTo(detailView).offset(23)
            make.left.equalTo(detailView).offset(25)
        }
        
        totalPriceTitle.snp.makeConstraints { make in
            make.top.equalTo(priceAgreementLabel.snp.bottom).offset(14)
            make.left.equalTo(detailView).offset(25)
        }
        
        totalPrice.snp.makeConstraints { make in
            make.top.equalTo(totalPriceTitle.snp.bottom).offset(2)
            make.left.equalTo(detailView).offset(25)
        }
        
        sponsorName.snp.makeConstraints { make in
            make.top.equalTo(totalPrice.snp.bottom).offset(11)
            make.left.equalTo(detailView).offset(25)
        }
        
        sponsorPrice.snp.makeConstraints { make in
            make.top.equalTo(sponsorName.snp.bottom).offset(2)
            make.left.equalTo(detailView).offset(25)
        }
        
        finalPriceTitle.snp.makeConstraints { make in
            make.top.equalTo(sponsorPrice.snp.bottom).offset(11)
            make.left.equalTo(detailView).offset(25)
        }
        
        finalPrice.snp.makeConstraints { make in
            make.top.equalTo(finalPriceTitle.snp.bottom).offset(2)
            make.left.equalTo(detailView).offset(25)
        }
    }
}

// MARK: - Animations

extension SubsidieOverview {
    func popIn(){
        self.isHidden = false
        self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animateKeyframes(withDuration: 0.2, delay: 0.0, options: UIView.KeyframeAnimationOptions.calculationModeDiscrete, animations: {
            self.transform = .identity
        }, completion:{(_ finish : Bool) in
            
        })
        
    }
    
    @objc func popOut() {
        self.transform = .identity
        UIView.animateKeyframes(withDuration: 0.2, delay: 0.0, options: UIView.KeyframeAnimationOptions.calculationModeDiscrete, animations: {
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }, completion:{(_ finish : Bool) in
            self.isHidden = true}
        )
    }
}
