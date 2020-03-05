//
//  EnablePersonalInformationViewController.swift
//  Me-iOS
//
//  Created by Daniel Tcacenco on 3/2/20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class EnablePersonalInformationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let barVC = segue.destination as? UITabBarController
        let nVC = barVC!.viewControllers![0] as? HiddenNavBarNavigationController
        let vc = nVC?.topViewController as? MVouchersViewController
        vc?.isFromLogin = true
    }

}
