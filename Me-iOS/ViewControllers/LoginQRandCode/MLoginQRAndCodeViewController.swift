//
//  MLoginQRAndCodeViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/6/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MLoginQRAndCodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginWithQr(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("togleStateWindow"), object: nil)
    }

}
