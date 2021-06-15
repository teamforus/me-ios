//
//  HomeTabViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 14.06.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

enum Tab: Int {
    case voucher = 0
    case qr = 1
    case profile = 2
    
}

class HomeTabViewController: UITabBarController {
    
    static let shared = HomeTabViewController()
    
    let vouchersViewController = TransactionManager.shared.vouchersScreen()
    
    let qrViewController = TransactionManager.shared.qrScreen()
    
    let profileViewController = TransactionManager.shared.profileScreen()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [vouchersViewController, qrViewController, profileViewController]
    }
    
    public func setTab(_ tab: Tab) {
        selectedIndex = tab.rawValue
    }

}
