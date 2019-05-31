//
//  MSuccessEmailViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MSuccessEmailViewController: UIViewController {
    
    lazy var successEmailViewModel: SuccessEmailViewModel = {
        return SuccessEmailViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(authorizeToken(notifcation:)),
            name: NotificationName.AuthorizeTokenEmail,
            object: nil)
    }
    
    @objc func authorizeToken(notifcation: Notification){
        
        successEmailViewModel.complete = { [weak self] (token) in
            
            DispatchQueue.main.async {
                
                UserDefaults.standard.set(token, forKey: "TOKEN")
                UserDefaults.standard.set(true, forKey: "isLoged")
                UserDefaults.standard.synchronize()
                self?.performSegue(withIdentifier: "goToMain", sender: self)
                
            }
        }
        
        if let token = notifcation.userInfo?["authToken"] as? String {
            
          successEmailViewModel.initCheckAuthorize(token: token)
            
        }
        
        
    }
    
    @IBAction func openMailApp(_ sender: Any) {
        if let mailURL = NSURL(string: "message://") {
            if UIApplication.shared.canOpenURL(mailURL as URL) {
                UIApplication.shared.open(mailURL as URL, options: [:],
                                          completionHandler: {
                                            (success) in }) }
            
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
