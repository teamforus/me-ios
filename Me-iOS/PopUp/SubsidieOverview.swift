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
    
    var topDetailToPriceConstraints: NSLayoutConstraint!
    var topDetailConstraints: NSLayoutConstraint!
    
    let bodyView: Background_DarkMode = {
        let view = Background_DarkMode()
        view.colorName = "Gray_Dark_DarkTheme"
        view.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 16)
        return view
    }()
    
    
    // MARK: - Properties
    
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
            vc.bodyViewHeightConstraints.constant = 150
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
        
        self.topDetailConstraints.isActive = false
        self.topDetailToPriceConstraints.isActive = true
    }
    
    func showFreeState(subsidie: Subsidie, vc: MPaymentActionViewController) {
        self.infoLabel.isHidden = true
        self.priceLabel.text = Localize.free()
        self.topDetailConstraints.isActive = false
        self.topDetailToPriceConstraints.isActive = true
        if (subsidie.sponsor_subsidy?.double)! > 0.00 {
            self.totalPriceTitle.text = Localize.subsid_by(subsidie.sponsor?.name ?? "")
            self.totalPrice.text = String("€ \(subsidie.sponsor_subsidy?.showDeciaml())").replacingOccurrences(of: ".", with: ",")
            vc.subsidieOverviewHeightConstraints.constant = 160
        }else {
            vc.subsidieOverviewHeightConstraints.constant = 110
        }
    }
    
    func showDiscontFixedState(subsidie: Subsidie, vc: MPaymentActionViewController) {
        self.totalPrice.text = String("€ \(subsidie.price_discount!.showDeciaml())").replacingOccurrences(of: ".", with: ",")
        if (subsidie.sponsor_subsidy?.double)! > 0.00 {
            self.sponsorName.text = Localize.subsid_by(subsidie.sponsor?.name ?? "")
            self.sponsorPrice.text = String("€ \(subsidie.sponsor_subsidy!.showDeciaml())").replacingOccurrences(of: ".", with: ",")
            vc.subsidieOverviewHeightConstraints.constant = 170
        }else {
            vc.subsidieOverviewHeightConstraints.constant = 130
        }
        self.topDetailConstraints.isActive = true
        self.topDetailToPriceConstraints.isActive = false
        
    }
    
    func showDiscountPercentageState(subsidie: Subsidie, vc: MPaymentActionViewController) {
        self.totalPriceTitle.text = Localize.discount()
        self.totalPrice.text = String("\(subsidie.price_discount!)%").replacingOccurrences(of: ".00", with: "")
        self.infoLabel.isHidden = true
        self.priceLabel.isHidden = true
        self.topDetailConstraints.isActive = true
        self.topDetailToPriceConstraints.isActive = false
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
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
        addSubviewsBodyView()
        addDetailViewSubviews()
    }
    
    private func addSubviewsBodyView() {
        let views = [infoLabel, priceLabel, detailView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
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
        
        NSLayoutConstraint.activate([
            bodyView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            bodyView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            bodyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            bodyView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 30),
            infoLabel.centerXAnchor.constraint(equalTo: bodyView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10),
            priceLabel.centerXAnchor.constraint(equalTo: bodyView.centerXAnchor)
        ])
        
        topDetailConstraints = detailView.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 0)
        topDetailConstraints.isActive = false
        topDetailToPriceConstraints = detailView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 14)
        NSLayoutConstraint.activate([
            topDetailConstraints,
            topDetailToPriceConstraints,
            detailView.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 0),
            detailView.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: 0),
            detailView.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            priceAgreementLabel.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 23),
            priceAgreementLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            totalPriceTitle.topAnchor.constraint(equalTo: priceAgreementLabel.bottomAnchor, constant: 14),
            totalPriceTitle.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            totalPrice.topAnchor.constraint(equalTo: totalPriceTitle.bottomAnchor, constant: 2),
            totalPrice.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            sponsorName.topAnchor.constraint(equalTo: totalPrice.bottomAnchor, constant: 11),
            sponsorName.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            sponsorPrice.topAnchor.constraint(equalTo: sponsorName.bottomAnchor, constant: 2),
            sponsorPrice.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            finalPriceTitle.topAnchor.constraint(equalTo: sponsorPrice.bottomAnchor, constant: 11),
            finalPriceTitle.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            finalPrice.topAnchor.constraint(equalTo: finalPriceTitle.bottomAnchor, constant: 2),
            finalPrice.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 25)
        ])
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
