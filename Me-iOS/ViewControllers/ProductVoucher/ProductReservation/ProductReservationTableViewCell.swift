//
//  ProductReservationTableViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 8/22/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class ProductReservationTableViewCell: UITableViewCell {
    static let identifier = "ProductReservationTableViewCell"
    
    // MARK: - Parameters
    var ticketImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleToFill
        imageView.image = Image.voucherTicketIcon
        return imageView
    }()
    
    var titleVoucher: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansBold(size: 20)
        return label
    }()
    
    var priceVoucher: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = R.font.googleSansBold(size: 20)
        label.textColor = Color.blueText
        return label
    }()
    
    var iconVoucher: RoundImageView = {
        let imageView = RoundImageView(frame: .zero)
        imageView.image = Image.restingIcon
        return imageView
    }()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ productReservation: Transaction) {
        titleVoucher.text = productReservation.product?.name ?? ""
        priceVoucher.text = String(productReservation.product?.price ?? "0") + "€"
        self.iconVoucher.loadImageUsingUrlString(urlString: productReservation.product?.photo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
    }
}

extension ProductReservationTableViewCell {
    // MARK: - Add Subviews
    private func addSubviews() {
        let views = [ticketImageView, titleVoucher, priceVoucher, iconVoucher]
        views.forEach { view in
            self.contentView.addSubview(view)
        }
    }
}

extension ProductReservationTableViewCell {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        ticketImageView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView).offset(10)
            make.left.equalTo(self.contentView).offset(15)
            make.right.equalTo(self.contentView).offset(-15)
            make.bottom.equalTo(self.contentView).offset(-10)
        }
        
        titleVoucher.snp.makeConstraints { make in
            make.top.equalTo(self.contentView).offset(30)
            make.left.equalTo(self.contentView).offset(35)
        }
        
        priceVoucher.snp.makeConstraints { make in
            make.top.equalTo(self.titleVoucher.snp.bottom).offset(12)
            make.left.equalTo(self.contentView).offset(35)
        }
        
        iconVoucher.snp.makeConstraints { make in
            make.left.equalTo(titleVoucher.snp.right).offset(5)
            make.centerY.equalTo(ticketImageView)
            make.right.equalTo(self.contentView).offset(-30)
        }
    }
}
