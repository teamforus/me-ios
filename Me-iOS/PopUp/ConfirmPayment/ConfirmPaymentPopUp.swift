//
//  ConfirmPaymentPopUp.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 6/4/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class ConfirmPaymentPopUp: UIViewController {
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var insuficientLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        paymentLabel.text = String(format: NSLocalizedString("Please confirm the transaction of %@", comment: ""), NSNumber(value: 20.0))
        insuficientLabel.text = String(format: NSLocalizedString("Insufficient funds on the voucher. Please, request extra payment of €%.02f", comment: ""), 20.0)
        
    }

    
    @IBAction func confirm(_ sender: Any) {
    }
    
    

}
