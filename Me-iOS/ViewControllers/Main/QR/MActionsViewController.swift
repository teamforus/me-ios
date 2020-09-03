//
//  MActionsViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 03.09.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MActionsViewController: UIViewController {
    
    let bodyView: Background_DarkMode = {
        let view = Background_DarkMode(frame: .zero)
        view.colorName = "Background_DarkTheme"
        return view
    }()
    
    private let headerView: Background_DarkMode = {
        let view = Background_DarkMode(frame: .zero)
        view.colorName = "Thin_Gray_DarkTheme"
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
    
    private let voucherImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleToFill
        imageView.image = R.image.xVoucherSurface()
        return imageView
    }()
    
    private let bodyvoucherView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private let nameVoucherLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "adasdsa"
        label.textColor = .black
        label.font = UIFont(name: "GoogleSans-Medium", size: 21)
        return label
    }()
    
    private let fundNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "adasdsa"
        label.textColor = .black
        label.font = UIFont(name: "GoogleSans-Regular", size: 14)
        return label
    }()
    
    private let imageViewVoucher: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    private let lineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = #colorLiteral(red: 0.8832242489, green: 0.878120482, blue: 0.8911749721, alpha: 1)
        return view
    }()
    
    private let chooseActionLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.text = "Kies een actie"
        label.font = UIFont(name: "GoogleSans-Medium", size: 24)
        return label
    }()
    
    private let infoPayLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Regulard", size: 11)
        let mainString = String(format: "Let op: de klant moet het bedrag aan de kassa betalen.")
        let range = (mainString as NSString).range(of: "Let op:")
        let attributedString = NSMutableAttributedString(string:mainString)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "GoogleSans-Bold", size: 16)! , range: range)
        label.attributedText = attributedString
        label.numberOfLines = 0
        return label
    }()
    
    private let tableView: TableView_Background_DarkMode = {
        let tableView = TableView_Background_DarkMode(frame: .zero)
        return tableView
    }()
    
    private let organizationView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()
    
    private let organizationNameLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Medium", size: 18)
        label.text = "adasdsa"
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = R.image.roundedRight()
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addSubviews()
        addConstraints()
        addHeaderSubviews()
        addHeaderdConstraints()
        addBodyvoucherViewSubviews()
        addBodyvoucherViewConstraints()
        addOranizationViewSubviews()
        addOranizationViewConstraints()
        setupVoucherImageView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(VoucherTableViewCell.self, forCellReuseIdentifier: VoucherTableViewCell.identifier)
    }
    
    func setupVoucherImageView() {
        let frame = self.view.frame
        let width = frame.width - 30
        voucherImageView.layer.shadowColor = UIColor.black.cgColor
        voucherImageView.layer.shadowOffset = CGSize(width: 0, height: 8)
        voucherImageView.layer.shadowOpacity = 0.3
        voucherImageView.layer.shadowRadius = 10
        voucherImageView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: 120)).cgPath
        voucherImageView.layer.shouldRasterize = false
    }
    
}

// MARK: - UITableViewDelegate

extension MActionsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VoucherTableViewCell.identifier, for: indexPath) as? VoucherTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
}

// MARK: - Add Subviews

extension MActionsViewController {
    
    func addSubviews() {
        let views = [bodyView, headerView, chooseActionLabel, infoPayLabel, organizationView, tableView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
    }
    
    func addHeaderSubviews() {
        let views = [backButton, titleLabel, bodyvoucherView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.headerView.addSubview(view)
        }
    }
    
    func addBodyvoucherViewSubviews() {
        let views = [voucherImageView, nameVoucherLabel, fundNameLabel, imageViewVoucher, lineView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.bodyvoucherView.addSubview(view)
        }
    }
    
    func addOranizationViewSubviews() {
        let views = [organizationNameLabel, arrowImageView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.organizationView.addSubview(view)
        }
    }
}

// MARK: - Add Constraints

extension MActionsViewController {
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            bodyView.topAnchor.constraint(equalTo: self.view.topAnchor),
            bodyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bodyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 241)
        ])
        
        NSLayoutConstraint.activate([
            chooseActionLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 29),
            chooseActionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
        ])
        
        NSLayoutConstraint.activate([
            infoPayLabel.topAnchor.constraint(equalTo: chooseActionLabel.bottomAnchor, constant: 6),
            infoPayLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            infoPayLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            organizationView.topAnchor.constraint(equalTo: infoPayLabel.bottomAnchor, constant: 6),
            organizationView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            organizationView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            organizationView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: organizationView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func addHeaderdConstraints() {
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 35)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bodyvoucherView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            bodyvoucherView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            bodyvoucherView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            bodyvoucherView.heightAnchor.constraint(equalToConstant: 153)
        ])
        
    }
    
    func addBodyvoucherViewConstraints() {
        NSLayoutConstraint.activate([
            voucherImageView.leadingAnchor.constraint(equalTo: bodyvoucherView.leadingAnchor, constant: 15),
            voucherImageView.trailingAnchor.constraint(equalTo: bodyvoucherView.trailingAnchor, constant: -15),
            voucherImageView.topAnchor.constraint(equalTo: bodyvoucherView.topAnchor, constant: 11)
        ])
        
        NSLayoutConstraint.activate([
            nameVoucherLabel.topAnchor.constraint(equalTo: bodyvoucherView.topAnchor, constant: 39),
            nameVoucherLabel.leadingAnchor.constraint(equalTo: bodyvoucherView.leadingAnchor, constant: 32),
            nameVoucherLabel.trailingAnchor.constraint(equalTo: imageViewVoucher.leadingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            fundNameLabel.topAnchor.constraint(equalTo: nameVoucherLabel.bottomAnchor, constant: 4),
            fundNameLabel.leadingAnchor.constraint(equalTo: bodyvoucherView.leadingAnchor, constant: 32),
            fundNameLabel.trailingAnchor.constraint(equalTo: imageViewVoucher.leadingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            imageViewVoucher.heightAnchor.constraint(equalToConstant: 70),
            imageViewVoucher.widthAnchor.constraint(equalToConstant: 70),
            imageViewVoucher.trailingAnchor.constraint(equalTo: bodyvoucherView.trailingAnchor, constant: -28),
            imageViewVoucher.topAnchor.constraint(equalTo: bodyvoucherView.topAnchor, constant: 36)
        ])
        
        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.bottomAnchor.constraint(equalTo: bodyvoucherView.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: bodyvoucherView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: bodyvoucherView.trailingAnchor)
        ])
    }
    
    func addOranizationViewConstraints() {
        NSLayoutConstraint.activate([
            organizationNameLabel.topAnchor.constraint(equalTo: organizationView.topAnchor),
            organizationNameLabel.leadingAnchor.constraint(equalTo: organizationView.leadingAnchor, constant: 15),
            organizationNameLabel.bottomAnchor.constraint(equalTo: organizationView.bottomAnchor),
            organizationNameLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: 15)
        ])
        
        NSLayoutConstraint.activate([
            arrowImageView.centerYAnchor.constraint(equalTo: organizationView.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: organizationView.trailingAnchor, constant: 15),
            arrowImageView.bottomAnchor.constraint(equalTo: organizationView.bottomAnchor),
            arrowImageView.heightAnchor.constraint(equalToConstant: 30),
            arrowImageView.widthAnchor.constraint(equalToConstant: 35)
        ])
    }
}
