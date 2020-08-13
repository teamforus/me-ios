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
        setupView()
        fetchUserData()
        setupUserDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSecurity()
    }
}

// MARK: - IBActions

extension MProfileViewController {
    
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
        
        showSimpleAlertWithAction(title: "Support", message: Localize.wouldYouLikeToSendUsYourFeedbackByEMail(),
                                  okAction: UIAlertAction(title: Localize.cancel(), style: .cancel, handler: { (action) in
                                  }),
                                  cancelAction: UIAlertAction(title: Localize.confirm(), style: .default, handler: { (action) in
                                    if MFMailComposeViewController.canSendMail() {
                                        let composeVC = MFMailComposeViewController()
                                        composeVC.mailComposeDelegate = self
                                        composeVC.setToRecipients(["feedback@forus.io"])
                                        composeVC.setSubject(Localize.myFeedbackAboutTheMeApp())
                                        composeVC.setMessageBody("", isHTML: false)
                                        self.present(composeVC, animated: true, completion: nil)
                                    }else{
                                        self.showSimpleAlert(title: Localize.warning(), message: Localize.mailServicesAreNotAvailable())
                                    }
                                  }))
    }
    
    @IBAction func crash(_ sender: Any) {
        Crashlytics.sharedInstance().crash()
    }
    
    @IBAction func creatEditPasscode(_ sender: Any) {
        
        if passcodeIsSet() {
            didChooseAppLocker(title: Localize.changePasscode(), subTitle: Localize.enterYourOldCode(), cancelButtonIsVissible: true, mode: .change)
        }else {
            didChooseAppLocker(title: Localize.loginCode(), subTitle: Localize.enterANewLoginCode(), cancelButtonIsVissible: true, mode: .create)
        }
    }
    
    @IBAction func deletePasscode(_ sender: Any) {
        
        didChooseAppLocker(title: Localize.turnOffLoginCode(), subTitle: Localize.enterANewLoginCode(), cancelButtonIsVissible: true, mode: .deactive)
    }
}

// MARK: - SetupView

extension MProfileViewController {
    
    private func setupView() {
        profileViewModel.vc = self
        let versionApp: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let buildAppNumber: AnyObject? = Bundle.main.infoDictionary?["CFBundleVersion"] as AnyObject
        #if (DEV || ALPHA )
        self.appVersionLabel.text = (versionApp as? String)! + " (" + (buildAppNumber as? String)! + ")"
        crashButton.isHidden = false
        #else
        self.appVersionLabel.text = (versionApp as? String)!
        crashButton.isHidden = true
        #endif
    }
    
    private func fetchUserData() {
        if isReachable() {
            profileViewModel.initProfile()
        }else {
            showInternetUnable()
        }
        
        profileViewModel.complete = { [weak self] (email, address) in
            
            DispatchQueue.main.async {
                self?.profileNameLabel.isHidden = true
                self?.emailLabel.text = email
            }
        }
    }
    
    private func setupUserDefaults() {
        if UserDefaults.standard.bool(forKey: UserDefaultsName.StartFromScanner) {
            startScannerSwitch.isOn = true
        }
        
        if UserDefaults.standard.bool(forKey: UserDefaultsName.UseTouchID) {
            userFaceIdSwitch.isOn = true
        }
        
        if UserDefaults.standard.bool(forKey: UserDefaultsName.AddressIndentityCrash) {
            crashReportSwitch.isOn = true
        }
    }
    
    private func setupSecurity() {
        if faceIDAvailable() {
            useSensorIdIcon.image = #imageLiteral(resourceName: "faceId-1")
            useSensorIdLabel.text = Localize.turnOnFaceID()
        }else {
            useSensorIdIcon.image = #imageLiteral(resourceName: "touchId")
            useSensorIdLabel.text = Localize.turnOnTouchID()
        }
        
        if passcodeIsSet() {
            changePasscodeLabel.text = Localize.changePasscode()
            self.didUpdateButtonStackView(isHiddeButtons: false, buttonHeightConstant: 249, verticalConstant: 66)
        }else{
            changePasscodeLabel.text = Localize.createPasscode()
            self.didUpdateButtonStackView(isHiddeButtons: true, buttonHeightConstant: 130, verticalConstant: 10)
        }
    }
}

// MARK: - UpdateButtons

extension MProfileViewController {
    
    func didUpdateButtonStackView(isHiddeButtons: Bool, buttonHeightConstant: CGFloat, verticalConstant: CGFloat){
        buttonConstraingHeight.constant = buttonHeightConstant
        faceIdVerticalSpacing.constant = verticalConstant
        turnOffPascodeView.isHidden = isHiddeButtons
        useFaceIdView.isHidden = isHiddeButtons
    }
    
}

// MARK: - Mail Delegate

extension MProfileViewController: MFMailComposeViewControllerDelegate{
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
