//
//  ActionTableViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 04.09.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class ActionTableViewCell: UITableViewCell {
  
  static let identifier = "ActionTableViewCell"
  
  private let bodyView: CustomCornerUIView = {
    let view = CustomCornerUIView()
    view.cornerRadius = 12
    view.shadowRadius = 10
    view.shadowOpacity = 0.1
    view.colorName = "Gray_Dark_DarkTheme"
    return view
  }()
  
  private let subsidieNameLabel: UILabel_DarkMode = {
    let label = UILabel_DarkMode()
    label.font = UIFont(name: "GoogleSans-Medium", size: 20)
    return label
  }()
  
  private let priceLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "GoogleSans-Regular", size: 20)
    label.textColor = #colorLiteral(red: 0.1702004969, green: 0.3387943804, blue: 1, alpha: 1)
    return label
  }()
  
  private let subsidieImageView: UIImageView = {
    let imageview = UIImageView()
    return imageview
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: ActionTableViewCell.identifier)
    selectionStyle = .none
    self.backgroundColor = .clear
    self.contentView.backgroundColor = .clear
    addSubview()
    setupConstraint()
    addBodySubviews()
    setupBodyConstraints()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  func setupActions(subsidie: Subsidie) {
    self.subsidieNameLabel.text = subsidie.name ?? ""
    self.priceLabel.text = subsidie.price_user_locale ?? ""
    self.subsidieImageView.loadImageUsingUrlString(urlString:subsidie.photo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
  }
}

// MARK: - Add Subviews

extension ActionTableViewCell {
  
  func addSubview() {
    self.contentView.addSubview(bodyView)
  }
  
  func addBodySubviews() {
    let views = [subsidieNameLabel, priceLabel, subsidieImageView]
    views.forEach { (view) in
      self.bodyView.addSubview(view)
    }
  }
}

// MARK: - Add Constraints

extension ActionTableViewCell {
  
  func setupConstraint() {
    bodyView.snp.makeConstraints { make in
        make.top.equalTo(self.contentView).offset(10)
        make.left.equalTo(self.contentView).offset(17)
        make.right.equalTo(self.contentView).offset(-17)
        make.bottom.equalTo(self.contentView)
    }
  }
  
  func setupBodyConstraints() {
    subsidieNameLabel.snp.makeConstraints { make in
        make.top.left.equalTo(bodyView).offset(20)
    }
    
    priceLabel.snp.makeConstraints { make in
        make.top.equalTo(subsidieNameLabel.snp.bottom).offset(6)
        make.left.equalTo(bodyView).offset(20)
    }
    
    subsidieImageView.snp.makeConstraints { make in
        make.centerY.equalTo(bodyView)
        make.height.width.equalTo(50)
        make.left.equalTo(subsidieNameLabel.snp.right).offset(20)
        make.right.equalTo(bodyView).offset(-20)
    }
  }
}
