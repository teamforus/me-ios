//
//  MLoginQRAndCodeViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/6/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MLoginQRAndCodeViewController: UIViewController {
    @IBOutlet var labels: [UILabel]!
    
    lazy var loginQrViewModel: LoginQrAndCodeViewModel = {
        return LoginQrAndCodeViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginQrViewModel.complete = { [weak self] (pinCode) in
            
            DispatchQueue.main.async {
                let stringCode: String = "\(pinCode)"
                if stringCode.count == 6{
                    var counter: Int = 0
                    self?.labels.forEach({ (label) in
                        label.text = String(stringCode[counter])
                        counter += 1
                    })
                }
            }
            
        }
        
        loginQrViewModel.initFetchPinCode()
        
         NotificationCenter.default.addObserver(self, selector: #selector(logIn), name: NotificationName.LoginQR, object: nil)
        
    }
    
    @objc func logIn(){
        performSegue(withIdentifier: "goToMain", sender: self)
    }
    
    @IBAction func loginWithQr(_ sender: Any) {
        NotificationCenter.default.post(name: NotificationName.TogleStateWindow, object: nil)
    }
    
}
