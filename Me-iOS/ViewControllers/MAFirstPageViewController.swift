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
                if isReacheble {
                    UserDefaults.standard.setValue("https://develop.test.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentName)
                }else {
                    UserDefaults.standard.setValue("https://dev.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentName)
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
            
            CheckWebSiteReacheble.checkWebsite(url: "https://staging.test.api.forus.io") { (isReacheble) in
                if isReacheble { UserDefaults.standard.setValue("https://staging.test.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentName)
                }else {
                    UserDefaults.standard.setValue("https://staging.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentName)
                }
            }
            
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
                    UserDefaults.standard.setValue("https://develop.test.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentName)
                }else {
                    UserDefaults.standard.setValue("https://dev.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentName)
                }
            }
            UserDefaults.standard.setValue("Dev", forKey: UserDefaultsName.EnvironmentName)
            chooseEnvironmentButton.setTitle("Dev", for: .normal)
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
