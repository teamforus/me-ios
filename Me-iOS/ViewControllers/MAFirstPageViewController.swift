//
//  MAFirstPageViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 8/27/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

enum EnvironmentType: Int {
    case production = 0
    case alpha = 1
    case demo = 2
    case dev = 3
    case custom = 4
}

import UIKit

class MAFirstPageViewController: UIViewController {
    @IBOutlet weak var environmnetView: UIStackView!
    @IBOutlet weak var chooseEnvironmentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEV
        chooseEnvironmentButton.isHidden = false
        if UserDefaults.standard.string(forKey: UserDefaultsName.EnvironmentURL) == nil{
            
            CheckWebSiteReacheble.checkWebsite(url: "https://develop.test.api.forus.io") { (isReacheble) in
                if isReacheble { UserDefaults.standard.setValue("https://develop.test.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentURL)
                }else {
                    UserDefaults.standard.setValue("https://dev.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentURL)
                }
            }
            
            chooseEnvironmentButton.setTitle("Dev", for: .normal)
            UserDefaults.standard.setValue("Dev", forKey: UserDefaultsName.EnvironmentName)
        }else {
            
            chooseEnvironmentButton.setTitle(UserDefaults.standard.string(forKey: UserDefaultsName.EnvironmentName), for: .normal)
        }
        #endif
    }
    
    
    @IBAction func chooseEnvironment(_ sender: UIButton) {
        environmnetView.isHidden = true
        switch sender.tag {
        case EnvironmentType.production.rawValue:
            UserDefaults.standard.setValue("https://api.forus.link/api/v1/", forKey: UserDefaultsName.EnvironmentURL)
            UserDefaults.standard.setValue("Production", forKey: UserDefaultsName.EnvironmentName)
            chooseEnvironmentButton.setTitle("Production", for: .normal)
            break
        case EnvironmentType.alpha.rawValue:
            
            UserDefaults.standard.setValue("https://staging.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentURL)
            UserDefaults.standard.setValue("Alpha", forKey: UserDefaultsName.EnvironmentName)
            chooseEnvironmentButton.setTitle("Alpha", for: .normal)
            break
        case EnvironmentType.demo.rawValue:
            UserDefaults.standard.setValue("https://demo.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentURL)
            UserDefaults.standard.setValue("Demo", forKey: UserDefaultsName.EnvironmentName)
            chooseEnvironmentButton.setTitle("Demo", for: .normal)
            break
        case EnvironmentType.dev.rawValue:
            CheckWebSiteReacheble.checkWebsite(url: "https://develop.test.api.forus.io") { (isReacheble) in
                if isReacheble {
                    UserDefaults.standard.setValue("https://develop.test.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentURL)
                }else {
                    UserDefaults.standard.setValue("https://dev.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentURL)
                }
            }
            UserDefaults.standard.setValue("Dev", forKey: UserDefaultsName.EnvironmentName)
            chooseEnvironmentButton.setTitle("Dev", for: .normal)
            break
            
        case EnvironmentType.custom.rawValue:
            let alertController = UIAlertController(title: "Add custom URL", message: "", preferredStyle: .alert)
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter Base URL"
                if self.chooseEnvironmentButton.titleLabel?.text == "Custom" {
                    textField.text = UserDefaults.standard.string(forKey: UserDefaultsName.EnvironmentURL)
                }
            }
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
                let firstTextField = alertController.textFields![0] as UITextField
                UserDefaults.standard.setValue(firstTextField.text ?? "", forKey: UserDefaultsName.EnvironmentURL)
                UserDefaults.standard.setValue("Custom", forKey: UserDefaultsName.EnvironmentName)
                self.chooseEnvironmentButton.setTitle("Custom", for: .normal)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action : UIAlertAction!) -> Void in })
            
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
            
            self.present(alertController, animated: true, completion: nil)
            break
        default:
            break
        }
        
    }
    
    @IBAction func showEnvironment(_ sender: Any) {
        environmnetView.isHidden = !environmnetView.isHidden
    }
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToLoginQR" {
            let generalVC = didSetPullUP(storyBoardName: "LoginQRAndCodeViewController", segue: segue)
            (generalVC.bottomViewController as! CommonBottomViewController).qrType = .AuthToken
        }
    }
    
    
}
