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
    var timer: Timer! = Timer()
    var token: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginQrViewModel.complete = { [weak self] (pinCode, token) in
            
            DispatchQueue.main.async {
                let stringCode: String = "\(pinCode)"
                if stringCode.count == 6{
                    var counter: Int = 0
                    self?.labels.forEach({ (label) in
                        label.text = String(stringCode[counter])
                        counter += 1
                    })
                }
                
                self?.token = token
                self?.timer = Timer.scheduledTimer(timeInterval: 10, target: self!, selector: #selector(self?.didCheckAuthorize), userInfo: nil, repeats: true)
            }
            
        }
        
        
        loginQrViewModel.completeAuthorize = { [weak self] (message, statusCode) in
            
            DispatchQueue.main.async {
                if message == "active"{
                    self?.timer.invalidate()
                    UserDefaults.standard.set(self?.token, forKey: "TOKEN")
                    UserDefaults.standard.synchronize()
                    self?.performSegue(withIdentifier: "goToMain", sender: self)
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

extension MLoginQRAndCodeViewController{
    
    @objc func didCheckAuthorize() {
        loginQrViewModel.initAuthorizeToken(token: token)
    }
}
