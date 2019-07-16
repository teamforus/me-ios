//
//  MProfileViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import MessageUI
import Crashlytics

class MProfileViewController: UIViewController {
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var buttonConstraingHeight: NSLayoutConstraint!
    @IBOutlet weak var changePassCodeView: CustomCornerUIView!
    @IBOutlet weak var turnOffPascodeView: CustomCornerUIView!
    @IBOutlet weak var useFaceIdView: CustomCornerUIView!
    @IBOutlet weak var faceIdVerticalSpacing: NSLayoutConstraint!
    @IBOutlet weak var changePasscodeLabel: UILabel!
    @IBOutlet weak var useSensorIdLabel: UILabel!
    @IBOutlet weak var useSensorIdIcon: UIImageView!
    @IBOutlet weak var crashButton: UIButton!
    @IBOutlet weak var startScannerSwitch: UISwitchCustom!
    @IBOutlet weak var userFaceIdSwitch: UISwitchCustom!
    @IBOutlet weak var crashReportSwitch: UISwitchCustom!
    
    lazy var profileViewModel: ProfileViewModel = {
        return ProfileViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let versionApp: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let buildAppNumber: AnyObject? = Bundle.main.infoDictionary?["CFBundleVersion"] as AnyObject
        #if (DEV || ALPHA )
        self.appVersionLabel.text = (versionApp as? String)! + " (" + (buildAppNumber as? String)! + ")"
        crashButton.isHidden = false
        #else
        self.appVersionLabel.text = (versionApp as? String)!
        crashButton.isHidden = true
        #endif
        
        
        profileViewModel.complete = { [weak self] (fullName, email) in
            
            DispatchQueue.main.async {
                
                if fullName == "" {
                    self?.profileNameLabel.isHidden = true
                }else {
                    self?.profileNameLabel.isHidden = false
                }
                self?.profileNameLabel.text = fullName
                self?.emailLabel.text = email
            }
            
        }
        
        
        
        if UserDefaults.standard.bool(forKey: UserDefaultsName.StartFromScanner) {
            
            startScannerSwitch.isOn = true
            
        }
        
        if UserDefaults.standard.bool(forKey: UserDefaultsName.UseTouchID) {
            
            userFaceIdSwitch.isOn = true
            
        }
        
        if UserDefaults.standard.bool(forKey: UserDefaultsName.AddressIndentityCrash) {
            
            crashReportSwitch.isOn = true
            
        }
        
        if faceIDAvailable() {
            
            useSensorIdIcon.image = #imageLiteral(resourceName: "faceId-1")
            useSensorIdLabel.text = "Turn on Face ID".localized()
            
        }else {
            
            useSensorIdIcon.image = #imageLiteral(resourceName: "touchId")
            useSensorIdLabel.text = "Turn on Touch ID".localized()
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isReachable() {
            
            profileViewModel.initProfile()
            
        }else {
            
            showInternetUnable()
            
        }
        
        if passcodeIsSet() {
            changePasscodeLabel.text = "Change passcode".localized()
            self.didUpdateButtonStackView(isHiddeButtons: false, buttonHeightConstant: 249, verticalConstant: 66)
            
            
        }else{
            
            changePasscodeLabel.text = "Create passcode".localized()
            self.didUpdateButtonStackView(isHiddeButtons: true, buttonHeightConstant: 130, verticalConstant: 10)
            
        }
        
        
        
    }
    
    @IBAction func switchStartFromScanner(_ sender: UISwitch) {
        if sender.isOn {
            
            UserDefaults.standard.setValue(true, forKey: UserDefaultsName.StartFromScanner)
            
        }else {
            
            UserDefaults.standard.setValue(false, forKey: UserDefaultsName.StartFromScanner)
            
        }
    }
    
    @IBAction func useFaceId(_ sender: UISwitch) {
        
        if sender.isOn {
            
            UserDefaults.standard.setValue(true, forKey: UserDefaultsName.UseTouchID)
            
        }else {
            
            UserDefaults.standard.setValue(false, forKey: UserDefaultsName.UseTouchID)
            
        }
        
    }
    
    @IBAction func sendCrashReports(_ sender: UISwitch) {
        
        if sender.isOn {
            
            UserDefaults.standard.setValue(true, forKey: UserDefaultsName.AddressIndentityCrash)
            
        }else {
            
            UserDefaults.standard.setValue(false, forKey: UserDefaultsName.AddressIndentityCrash)
            
        }
        
    }
    
    @IBAction func feedback(_ sender: Any) {
        
        showSimpleAlertWithAction(title: "Support", message: "Would you like to send us your feedback by e-mail?".localized(),
                                  okAction: UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: { (action) in
                                  }),
                                  cancelAction: UIAlertAction(title: "Confirm".localized(), style: .default, handler: { (action) in
                                    if MFMailComposeViewController.canSendMail() {
                                        
                                        let composeVC = MFMailComposeViewController()
                                        composeVC.mailComposeDelegate = self
                                        composeVC.setToRecipients(["feedback@forus.io"])
                                        composeVC.setSubject("My feedback about the Me app".localized())
                                        composeVC.setMessageBody("", isHTML: false)
                                        self.present(composeVC, animated: true, completion: nil)
                                        
                                    }else{
                                        
                                        self.showSimpleAlert(title: "Warning".localized(), message: "Mail services are not available".localized())
                                        
                                    }
                                  }))
        
    }
    
    @IBAction func crash(_ sender: Any) {
        Crashlytics.sharedInstance().crash()
    }
    
    @IBAction func creatEditPasscode(_ sender: Any) {
        
        
        if passcodeIsSet() {
            
            didChooseAppLocker(title: "Change passcode".localized(), subTitle: "Enter your old code".localized(), cancelButtonIsVissible: true, mode: .change)
            
        }else {
            
            didChooseAppLocker(title: "Login code".localized(), subTitle: "Enter a new login code".localized(), cancelButtonIsVissible: true, mode: .create)
            
        }
        
    }
    
    @IBAction func deletePasscode(_ sender: Any) {
        
        didChooseAppLocker(title: "Turn off login code".localized(), subTitle: "Enter login code".localized(), cancelButtonIsVissible: true, mode: .deactive)
    }
    
    
    
}

extension MProfileViewController {
    
    func didUpdateButtonStackView(isHiddeButtons: Bool, buttonHeightConstant: CGFloat, verticalConstant: CGFloat){
        buttonConstraingHeight.constant = buttonHeightConstant
        faceIdVerticalSpacing.constant = verticalConstant
        turnOffPascodeView.isHidden = isHiddeButtons
        useFaceIdView.isHidden = isHiddeButtons
    }
    
}

extension MProfileViewController: MFMailComposeViewControllerDelegate{
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
