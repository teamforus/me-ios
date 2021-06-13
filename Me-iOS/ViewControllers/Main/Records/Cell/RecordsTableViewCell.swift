//
//  RecordsTableViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/27/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class RecordsTableViewCell: UITableViewCell {
    
    static let identifier = "RecordsTableViewCell"
    
    // MARK: - Parameters
    var typeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = R.font.googleSansRegular(size: 13)
        label.textColor = Color.lightGrayText
        return label
    }()
    
    var nameLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansBold(size: 18)
        return label
    }()
    
    var bodyView: CustomCornerUIView = {
        let view = CustomCornerUIView(frame: .zero)
        view.cornerRadius = 8
        view.shadowOpacity = 0.1
        view.shadowRadius = 10
        view.colorName = "Gray_Dark_DarkTheme"
        view.shadowOffset = CGSize(width: 0, height: 0)
        if #available(iOS 11.0, *) {
        view.selectedShadowColor = UIColor(named: "Black_Light_DarkTheme")!
        } else {}
        return view
    }()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstaints()
        self.selectionStyle = .none
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 11.0, *) {
            self.bodyView.selectedShadowColor = UIColor(named: "Black_Light_DarkTheme")!
        } else {}
    }
    
    func setup(_ record: Record) {
        typeLabel.text = record.name ?? ""
        nameLabel.text = record.value
        setupAccessibility(with: record.name ?? "", and: record.value ?? "")
    }
}

extension RecordsTableViewCell {
    // MARK: - Add Subviews
    private func addSubviews() {
        contentView.addSubview(bodyView)
        let views = [typeLabel, nameLabel]
        views.forEach { view in
            bodyView.addSubview(view)
        }
    }
}

extension RecordsTableViewCell {
    // MARK: - Setup Constraints
    private func setupConstaints() {
        bodyView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-10)
            make.bottom.equalTo(contentView).offset(-6)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.left.equalTo(bodyView).offset(19)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(3)
            make.left.equalTo(bodyView).offset(19)
        }
    }
}

extension RecordsTableViewCell {
    // MARK: - Setup Accessiblity
    func setupAccessibility(with recordName: String, and recordValue: String) {
        self.bodyView.setupAccesibility(description: Localize.record() + recordName + recordValue, accessibilityTraits: .button)
    }
}
