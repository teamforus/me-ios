//
//  MACrashConfirmViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 1/15/19.
//  Copyright © 2019 Foundation Forus. All rights reserved.
//

import UIKit

class MCrashConfirmViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimate()
    }
    
    @IBAction func confirmCrashAddress(_ sender: Any) {
        removeAnimate()
    }
    
    @IBAction func switchCrashAddressOn(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: UserDefaultsName.AddressIndentityCrash)
        }else {
            UserDefaults.standard.set(false, forKey: UserDefaultsName.AddressIndentityCrash)
        }
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        removeAnimate()
    }
}
