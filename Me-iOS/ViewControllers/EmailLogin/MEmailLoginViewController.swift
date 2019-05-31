//
//  MEmailLoginViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class MEmailLoginViewController: UIViewController {
    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    @IBOutlet weak var validationIcon: UIImageView!
    @IBOutlet weak var confirmButton: ShadowButton!
    
    lazy var emailLoginViewModel: EmailLoginViewModel = {
        return EmailLoginViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailLoginViewModel.complete = { [weak self] (statusCode) in
            
            DispatchQueue.main.async {
                
                if statusCode == 200 {
                    
                self?.performSegue(withIdentifier: "goToSuccessMail", sender: self)
                    
                }else {
                    
                    self?.showSimpleAlert(title: "Email", message: "Such email does not exist.")
                    
                }
            }
            
        }
    }
    
    @IBAction func validateEmailField(textField:SkyFloatingLabelTextField) {
        
            if validateEmail(emailField.text!){
                
                validationIcon.isHidden = false
                confirmButton.backgroundColor = #colorLiteral(red: 0.7647058824, green: 0.7647058824, blue: 0.7647058824, alpha: 1)
                confirmButton.isEnabled = false
                
            }else{
                
                validationIcon.isHidden = true
                confirmButton.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.3921568627, blue: 0.9764705882, alpha: 1)
                confirmButton.isEnabled = true
            }
    }
    

    @IBAction func confirm(_ sender: Any) {
        
        emailLoginViewModel.initLoginByEmail(email: emailField.text ?? "")
    }
    

}
