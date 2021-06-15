//
//  Navigator.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 14.06.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

class Navigator: NSObject {

    var navController: HiddenNavBarNavigationController!
    
    override init() {
        super.init()
    }
    
    func configure(_ navController: HiddenNavBarNavigationController) {
        self.navController = navController
    }
    
    func navigate(to destination: Destination) {
        switch destination {
        case .successEmail(let email):
            let emailVC = MSuccessEmailViewController(email: email)
            navController.show(emailVC, sender: nil)
            
        case .successRegistre:
            let registerVC = MSuccessRegisterViewController()
            navController.show(registerVC, sender: nil)
            
        case .enablePersonalInfo:
            let enableInfoVC = EnablePersonalInformationViewController(navigator: self)
            navController.show(enableInfoVC, sender: nil)
            
        case .home:
            let tabBarController = HomeTabViewController()
            navController.present(tabBarController, animated: true)
        }
    }
    
    
    enum Destination {
        case successEmail(_ email: String)
        case successRegistre
        case enablePersonalInfo
        case home
    }
}
