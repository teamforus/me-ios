//
//  MBranchesTableViewCell.swift
//  Me-iOS
//
//  Created by mac on 02.02.2021.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MBranchesTableViewCell: UITableViewCell {
  static let identifier = "MBranchesTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
