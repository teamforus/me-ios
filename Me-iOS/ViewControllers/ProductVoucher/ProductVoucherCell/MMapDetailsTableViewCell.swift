//
//  MMapDetailsTableViewCell.swift
//  Me-iOS
//
//  Created by mac on 02.02.2021.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit
import MapKit

class MMapDetailsTableViewCell: UITableViewCell {
  static let identifier = "MMapDetailsTableViewCell"
  var voucher: Voucher!
  
  private let bodyView: UIView = {
      let bodyView = UIView(frame: .zero)
      bodyView.backgroundColor = .white
      bodyView.roundCorners(corners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 16)
    
      return bodyView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "Zwembad"
    label.font = R.font.googleSansMedium(size: 21)
    return label
  }()
  
  private let subTitleLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "Zwembad"
    label.font = R.font.googleSansRegular(size: 14)
    label.textColor = #colorLiteral(red: 0.556738019, green: 0.5565260053, blue: 0.577188611, alpha: 1)
    return label
  }()
  
 
  private let iconImage: UIImageView = {
    let imageQRCodeVoucher = UIImageView(frame: .zero)
    imageQRCodeVoucher.image = UIImage(named: "iconVoucher")
    imageQRCodeVoucher.contentMode = .scaleAspectFit
    return imageQRCodeVoucher
  }()
  
  private let mapView: MKMapView = {
    let mapView = MKMapView(frame: .zero)
    mapView.mapType = MKMapType.standard
    mapView.isZoomEnabled = true
    mapView.isScrollEnabled = true
    return mapView
  }()
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      addSubviews()
      setupConstraints()
      self.backgroundColor = #colorLiteral(red: 0.9685223699, green: 0.9686879516, blue: 0.9685119987, alpha: 1)
  }
  
  func setupVoucher(voucher: Voucher?) {
    self.titleLabel.text = voucher?.fund?.organization?.name ?? ""
    self.subTitleLabel.text = voucher?.product?.organization?.name ?? ""
    self.iconImage.loadImageUsingUrlString(urlString: voucher?.product?.organization?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
  }
  
  required init?(coder: NSCoder) {
      super.init(coder: coder)
  }
}

extension MMapDetailsTableViewCell {
    func addSubviews() {
        let views = [bodyView, titleLabel, subTitleLabel, iconImage, mapView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(view)
        }
    }
    func setupConstraints(){
        NSLayoutConstraint.activate([
            bodyView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 40),
            bodyView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            bodyView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant:  -10),
            bodyView.heightAnchor.constraint(equalToConstant: 70),
            bodyView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0)
        ])
      
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.bodyView.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor, constant: 67),
        ])
      

        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: self.bodyView.topAnchor, constant: 52),
            subTitleLabel.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor, constant: 67),
        ])

      
      NSLayoutConstraint.activate([
        iconImage.topAnchor.constraint(equalTo: self.bodyView.topAnchor, constant: 22),
        iconImage.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor, constant: 8),
        iconImage.heightAnchor.constraint(equalToConstant: 44),
        iconImage.widthAnchor.constraint(equalToConstant: 44),
      ])
  
      NSLayoutConstraint.activate([
        mapView.topAnchor.constraint(equalTo: self.bodyView.topAnchor, constant: 84),
        mapView.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor, constant: 3),
        mapView.trailingAnchor.constraint(equalTo: self.bodyView.trailingAnchor, constant: -3)
      ])
      
    }
}
