//
//  MConfirmRegisterViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MConfirmRegisterViewController: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var primaryEmail: String!
    var firstName: String!
    var lastName: String!
    lazy var successEmailViewModel: SuccessEmailViewModel = {
        return SuccessEmailViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeLabel.text = "Welcome to Me, ".localized() + firstName + " " + lastName + "! " + "Before we get started, please confirm your email address.".localized()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(authorizeToken(notifcation:)),
            name: NotificationName.AuthorizeTokenSignUp,
            object: nil)
        
    }
    
    
    @objc func authorizeToken(notifcation: Notification){
       
        successEmailViewModel.complete = { [weak self] (token) in
            
            DispatchQueue.main.async {
                
                UserDefaults.standard.set(token, forKey: UserDefaultsName.Token)
                UserDefaults.standard.set(true, forKey: UserDefaultsName.UserIsLoged)
                CurrentSession.shared.token = token
                self?.addShortcuts(application: UIApplication.shared)
                UserDefaults.standard.synchronize()
                self?.performSegue(withIdentifier: "goToMain", sender: self)
                
            }
        }
        
        if let token = notifcation.userInfo?["authToken"] as? String {
            
            successEmailViewModel.initCheckAuthorize(token: token)
            
        }
        
    }
    
    @IBAction func openMail(_ sender: Any) {
        
        if let mailURL = NSURL(string: "message://") {
            if UIApplication.shared.canOpenURL(mailURL as URL) {
                UIApplication.shared.open(mailURL as URL, options: [:],
                                          completionHandler: {
                                            (success) in }) }
            
        }else {
            showSimpleAlert(title: "Warning".localized(), message: "You don't have mail app on your device.")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let barVC = segue.destination as? UITabBarController
        let nVC = barVC!.viewControllers![0] as? HiddenNavBarNavigationController
        let vc = nVC?.topViewController as? MVouchersViewController
        vc?.isFromLogin = true
    }
}
