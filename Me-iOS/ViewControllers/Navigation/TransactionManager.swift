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


// MARK: - Login
extension TransactionManager {
    func loginScreen() -> MeNavigationController {
        let viewController = MAFirstPageViewController(navigator: Navigator())
        let navController = MeNavigationController(rootViewController: viewController)
        viewController.navigator.configure(navController)
        return navController
    }
}

// MARK: - Tab Bar
extension TransactionManager {
    func tabBarControllerScreen() -> HomeTabViewController {
        let tabBarController = HomeTabViewController()
        return tabBarController
    }
}

// MARK: - Vouchers
extension TransactionManager {
    func vouchersScreen() -> MeNavigationController {
        let viewController = MVouchersViewController(navigator: Navigator())
        viewController.isFromLogin = true
        let navController = MeNavigationController(rootViewController: viewController)
        navController.tabBarItem = UITabBarItem(title: "Vouchers", image: Image.voucherTabIcon, tag: Tab.voucher.rawValue)
        viewController.navigator.configure(navController)
        return navController
    }
}

// MARK: - QR
extension TransactionManager {
    func qrScreen() -> MeNavigationController {
        let viewController = MQRViewController(navigator: Navigator())
        let navController = MeNavigationController(rootViewController: viewController)
        viewController.tabBarItem = UITabBarItem(title: "QR", image: Image.qrTabIcon, tag: Tab.qr.rawValue)
        viewController.navigator.configure(navController)
        return navController
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

// MARK: - Subsidie
extension TransactionManager {
    func actionsScreen(voucher: Voucher) -> MeNavigationController {
        let viewController = MActionsViewController(navigator: Navigator(), voucher: voucher)
        let navController = MeNavigationController(rootViewController: viewController)
        viewController.navigator.configure(navController)
        return navController
    }
}

// MARK: - Product Reservation
extension TransactionManager {
    func productReservationScreen(voucherTokens: [Transaction], voucher: Voucher) -> MeNavigationController {
        let viewController = MProductReservationViewController(navigator: Navigator(), voucherTokens: voucherTokens, voucher: voucher)
        let navController = MeNavigationController(rootViewController: viewController)
        viewController.navigator.configure(navController)
        return navController
    }
}

// MARK: - Payment
extension TransactionManager {
    func paymentScreen(voucher: Voucher) -> MeNavigationController {
        let viewController = MPaymentViewController(navigator: Navigator(), voucher: voucher)
        let navController = MeNavigationController(rootViewController: viewController)
        viewController.navigator.configure(navController)
        return navController
    }
}

