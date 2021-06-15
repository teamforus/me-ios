//
//  TransactionManager.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 14.06.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

class TransactionManager {
    
    static let shared = TransactionManager()
    
    enum Storyboards: String {
        case profile = "Profile"
    }
    enum ViewControllers {
        enum Profile: String {
            case profile = "content"
        }
    }
    
    typealias StoryboardIdentifier = Storyboards
    
    private func loadScene<ViewControllerIdentifier: RawRepresentable>(storyboard: StoryboardIdentifier, viewController: ViewControllerIdentifier) -> UIViewController where ViewControllerIdentifier.RawValue == String {
        print(storyboard.rawValue)
        print(viewController.rawValue)
        return UIStoryboard.init(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: viewController.rawValue)
    }
    
}

// MARK: - Vouchers
extension TransactionManager {
    func vouchersScreen() -> HiddenNavBarNavigationController {
        let viewController = MVouchersViewController()
        viewController.isFromLogin = true
        let navController = HiddenNavBarNavigationController(rootViewController: viewController)
        navController.tabBarItem = UITabBarItem(title: "Vouchers", image: Image.voucherTabIcon, tag: Tab.voucher.rawValue)
        return navController
    }
}

// MARK: - QR
extension TransactionManager {
    func qrScreen() -> MQRViewController {
        let viewController = MQRViewController()
        viewController.tabBarItem = UITabBarItem(title: "QR", image: Image.qrTabIcon, tag: Tab.qr.rawValue)
        return viewController
    }
}

// MARK: - Profile
extension TransactionManager {
    func profileScreen() -> MProfileViewController {
        let viewController = loadScene(storyboard: Storyboards.profile, viewController: ViewControllers.Profile.profile) as! MProfileViewController
        viewController.tabBarItem = UITabBarItem(title: Localize.profile(), image: Image.profileTabIcon, tag: Tab.voucher.rawValue)
        return viewController
    }
}
