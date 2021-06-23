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
    
    var tabBarHeight: CGFloat {
        if view.safeAreaInsets.bottom == 0 { // check if screen has safe area
            return 60
        } else {
            return 100
        }
    }
    
    let vouchersViewController = TransactionManager.shared.vouchersScreen()
    
    let qrViewController = TransactionManager.shared.qrScreen()
    
    let profileViewController = TransactionManager.shared.profileScreen()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        viewControllers = [vouchersViewController, qrViewController, profileViewController]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabBar.frame.size.height = tabBarHeight
        tabBar.frame.origin.y = view.frame.height - tabBarHeight
    }
    
    public func setTab(_ tab: Tab) {
        selectedIndex = tab.rawValue
    }
    
    func configureSubviews() {
        hidesBottomBarWhenPushed = true
    }

}
