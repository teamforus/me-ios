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
        view.colorName = "LighGray_DarkTheme"
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
    
    func configureSubsidie(subsidie: Subsidie, and fund: Fund?) {
            
      switch subsidie.no_price_type {
      case SubsidieType.regular.rawValue:
        sponsorName.text = Localize.subsid_by(fund?.organization?.name ?? "")
        
        let sponsorPrice = Double(subsidie.price ?? "0.0")! - Double(subsidie.price_user ?? "0.0")!
        if sponsorPrice != 0.0 {
            self.sponsorPrice.text =  String("€ \(String(sponsorPrice).showDeciaml())").replacingOccurrences(of: ".", with: ",")
        }
        
        if let priceUser = subsidie.price_user {
            self.priceLabel.text = String("€ \(priceUser)").replacingOccurrences(of: ".", with: ",")
            finalPrice.text = String("€ \(priceUser.showDeciaml())").replacingOccurrences(of: ".", with: ",")
        }
      case SubsidieType.free.rawValue:
        detailView.isHidden = true
      case SubsidieType.discountFixed.rawValue:
        self.totalPrice.text = String("€ \(subsidie.no_price_discount?.showDeciaml())").replacingOccurrences(of: ".", with: ",")
      case SubsidieType.discountPercentage.rawValue:
        break
      default:
        break
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
        
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 14),
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
