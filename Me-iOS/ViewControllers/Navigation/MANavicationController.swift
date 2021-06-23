//
//  MANavicationController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/23/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MANavicationController: NSObject {
    
    fileprivate weak var navigationController: UINavigationController?
    
    init(controller: UINavigationController) {
        self.navigationController = controller
        
        super.init()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

extension MANavicationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (navigationController?.viewControllers.count ?? 0) > 1
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

}


class MeNavigationController: UINavigationController {
    
    // MARK: - Properties
    
    private var popRecognizer: MANavicationController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopRecognizer()
        delegate = self
    }
    
    // MARK: - Setup
    
    private func setupPopRecognizer() {
        popRecognizer = MANavicationController(controller: self)
    }
}

extension MeNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.navigationBar.barTintColor = R.color.background_DarkTheme()
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController.navigationBar.shadowImage =  UIImage()
        navigationController.navigationBar.isTranslucent = true
        viewController.navigationItem.rightBarButtonItem = nil
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
        let image = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        viewController.navigationController?.navigationBar.backIndicatorImage = image
        viewController.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        if #available(iOS 11.0, *) {
            viewController.navigationController?.navigationBar.tintColor = UIColor(named: "Black_Light_DarkTheme")
        } else {
            viewController.navigationController?.navigationBar.tintColor = .black
        }
        viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        switch viewController {
        case is MAFirstPageViewController, is MSuccessEmailViewController, is EnablePersonalInformationViewController, is MSuccessRegisterViewController:
            setNavigationBarHidden(true, animated: true)
            
        case is MVouchersViewController:
            self.navigationBar.prefersLargeTitles = true
            viewController.title = "Vouchers"
            let barButtonItem = UIBarButtonItem(customView: (viewController as? MVouchersViewController)!.transactionButton)
            viewController.navigationItem.rightBarButtonItem = barButtonItem
            
        case is MTransactionsViewController:
            self.navigationBar.prefersLargeTitles = true
            viewController.title = Localize.transactions()
            
        case is ProductVoucherViewController:
            self.navigationBar.prefersLargeTitles = false
            viewController.title = Localize.product_voucher()
            
        case is MVoucherViewController:
            self.navigationBar.prefersLargeTitles = false
            viewController.title = "Voucher"
        default: ()
        }
    }
}
