//
//  Extension+ReuseIdentifier.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 15.07.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
