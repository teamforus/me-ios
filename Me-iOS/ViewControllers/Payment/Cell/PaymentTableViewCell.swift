//
//  PaymentTableViewCell.swift
//  Me-iOS
//
//  Created by Daniel Tcacenco on 24.11.2023.
//  Copyright © 2023 Tcacenco Daniel. All rights reserved.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {
    
    var actionHandleBlock: ((_ button:ActionButton) -> ())?
    
    static let identifier = "PaymentTableViewCell"

    var payButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.backgroundColor = Color.blueText
        button.setTitle(Localize.complete_amount(),
                        for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.rounded(cornerRadius: 9)
        return button
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup View
extension PaymentTableViewCell {
    private func setupView() {
        self.contentView.addSubview(payButton)
        payButton.snp.makeConstraints { make in
            make.top.equalTo(self.contentView)
            make.left.right.bottom.equalTo(self.contentView).inset(10)
        }
    }
}
