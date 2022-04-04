//
//  TextTableViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 20.01.2021.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {
  static let identifier = "TextTableViewCell"
  
  // MARK: - Parameters
  
  var informationLabel: UILabel_DarkMode = {
    let label = UILabel_DarkMode(frame: .zero)
    label.font = R.font.googleSansRegular(size: 16)
    label.numberOfLines = 0
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    addSubviews()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCellInfo(by type: PrivacyType) {
    switch type {
    case .sourceOfInformation:
      setupSourceOfInformation()
    case .privelege:
      setupPrivileges()
    case .feedbackText:
      setupFeedbackText()
    case .readAboutPrivacy:
      setupReadAboutPrivacy()
    default:
      break
    }
  }
}

extension TextTableViewCell {
  // MARK: - Setup Text
  private func setupSourceOfInformation() {
      let mainString = String(format: Localize.source_of_information())
      let firstRange = (mainString as NSString).range(of: Localize.source_information_title())
    let theredRange = (mainString as NSString).range(of: "Privacy")
    
    let attributedString = NSMutableAttributedString(string:mainString)
    attributedString.addAttribute(NSAttributedString.Key.font, value: R.font.googleSansMedium(size: 20) as Any , range: firstRange)
    attributedString.addAttribute(NSAttributedString.Key.font, value: R.font.googleSansMedium(size: 20) as Any , range: theredRange)
    informationLabel.attributedText = attributedString
  }
  
  private func setupPrivileges() {
      let mainString = Localize.priveleges_information()
      let range = (mainString as NSString).range(of: Localize.priveleges_title())
    
    let attributedString = NSMutableAttributedString(string:mainString)
    attributedString.addAttribute(NSAttributedString.Key.font, value: R.font.googleSansMedium(size: 17) as Any , range: range)
    informationLabel.attributedText = attributedString
  }
  
  private func setupFeedbackText() {
      informationLabel.text = Localize.feedback_text()
  }
  
  private func setupReadAboutPrivacy() {
      informationLabel.text = Localize.read_privacy()
  }
}

extension TextTableViewCell {
  // MARK: - Add Subviews
  private func addSubviews() {
    informationLabel.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(informationLabel)
  }
}

extension TextTableViewCell {
  // MARK: - Setup Constraints
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      informationLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
      informationLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 17),
      informationLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -17),
      informationLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
    ])
  }
}
