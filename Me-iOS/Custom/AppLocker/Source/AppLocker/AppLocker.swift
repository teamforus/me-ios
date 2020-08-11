//
//  AppALConstants.swift
//  AppLocker
//
//  Created by Oleg Ryasnoy on 07.07.17.
//  Copyright © 2017 Oleg Ryasnoy. All rights reserved.
//

import UIKit
import AudioToolbox
import LocalAuthentication

protocol AppLockerDelegate: class {
    func closePinCodeView(typeClose: typeClose)
}

enum typeClose: Int {
    case cancel = 0
    case create = 1
    case validate = 2
    case delete = 3
    case change = 4
    case logout = 5
}

public enum ALConstants {
    static let nibName = "AppLocker"
    static let kPincode = "pinCode" // Key for saving pincode to UserDefaults
    static var kLocalizedReason = "Unlock with sensor" // Your message when sensors must be shown
    static let duration = 0.3 // Duration of indicator filling
    static let maxPinLength = 4
    
    enum button: Int {
        case delete = 1000
        case cancel = 1001
    }
}

public struct ALAppearance { // The structure used to display the controller
    public var title: String?
    public var subtitle: String?
    public var image: UIImage?
    public var color: UIColor?
    public var isSensorsEnabled: Bool?
    public var cancelIsVissible: Bool?
    weak var delegate: AppLockerDelegate!
    public init() {}
}

public enum ALMode { // Modes for AppLocker
    case validate
    case change
    case deactive
    case create
}

public class AppLocker: UIViewController {
    
    // MARK: - Top view
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var submessageLabel: UILabel!
    @IBOutlet var pinIndicators: [Indicator]!
    weak var delegate: AppLockerDelegate!
    @IBOutlet weak var cancelButton: Button!
    var vc: UIViewController!
    var isCancelButton: Bool!
    
    // MARK: - Pincode
    private let context = LAContext()
    private var pin = "" // Entered pincode
    private var reservedPin = "" // Reserve pincode for confirm
    private var isFirstCreationStep = true
    private var savedPin: String? {
        get {
            return UserDefaults.standard.string(forKey: ALConstants.kPincode)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ALConstants.kPincode)
        }
    }
    
    fileprivate var mode: ALMode? {
        didSet {
            let mode = self.mode ?? .validate
            switch mode {
            case .create:
                messageLabel.text = "Login code".localized() // Your message for create mode
                submessageLabel.text = "Enter a new login code".localized() // Your message for create mode // Your submessage for create mode
            case .change:
                messageLabel.text = "Enter login code".localized() // Your submessage for change mode
            case .deactive:
                messageLabel.text = "Turn off login code".localized() // Your submessage for deactive mode
            case .validate:
                messageLabel.text = "Enter login code".localized() // Your submessage for validate mode
                isFirstCreationStep = false
            }
        }
    }
    
    private func precreateSettings () { // Precreate settings for change mode
        mode = .create
        clearView()
    }
    
    private func drawing(isNeedClear: Bool, tag: Int? = nil) { // Fill or cancel fill for indicators
        let results = pinIndicators.filter { $0.isNeedClear == isNeedClear }
        let pinView = isNeedClear ? results.last : results.first
        pinView?.isNeedClear = !isNeedClear
        
        UIView.animate(withDuration: ALConstants.duration, animations: {
            pinView?.backgroundColor = isNeedClear ? .clear : #colorLiteral(red: 0.2078431373, green: 0.3921568627, blue: 0.9764705882, alpha: 1)
        }) { _ in
            isNeedClear ? self.pin = String(self.pin.dropLast()) : self.pincodeChecker(tag ?? -1)
        }
    }
    
    private func pincodeChecker(_ pinNumber: Int) {
        if pin.count < ALConstants.maxPinLength {
            pin.append("\(pinNumber)")
            if pin.count == ALConstants.maxPinLength {
                switch mode ?? .validate {
                case .create:
                    createModeAction()
                case .change:
                    changeModeAction()
                case .deactive:
                    deactiveModeAction()
                case .validate:
                    validateModeAction()
                }
            }
        }
    }
    
    // MARK: - Modes
    private func createModeAction() {
        if isFirstCreationStep {
            isFirstCreationStep = false
            reservedPin = pin
            clearView()
            messageLabel.text = "Confirm the code".localized()
            submessageLabel.text = "Confirm the login code by entering it again.".localized()
        } else {
            confirmPin()
        }
    }
    
    private func changeModeAction() {
        pin == savedPin ? precreateSettings() : incorrectPinAnimation()
    }
    
    private func deactiveModeAction() {
        pin == savedPin ? removePin() : incorrectPinAnimation()
    }
    
    private func validateModeAction() {
        UserDefaults.standard.set(true, forKey: UserDefaultsName.PinCodeEnabled)
        pin == savedPin ? dismiss(animated: true, completion: nil) : incorrectPinAnimation()
        delegate.closePinCodeView(typeClose: .validate)
    }
    
    private func removePin() {
        UserDefaults.standard.set(false, forKey: UserDefaultsName.PinCodeEnabled)
        UserDefaults.standard.removeObject(forKey: ALConstants.kPincode)
        dismiss(animated: true, completion: nil)
        delegate.closePinCodeView(typeClose: .delete)
        
    }
    
    private func confirmPin() {
        UserDefaults.standard.set(true, forKey: UserDefaultsName.PinCodeEnabled)
        if pin == reservedPin {
            savedPin = pin
            dismiss(animated: true, completion: nil)
            delegate.closePinCodeView(typeClose: .create)
        } else {
            incorrectPinAnimation()
        }
    }
    
    private func incorrectPinAnimation() {
        pinIndicators.forEach { view in
            
            view.shake(delegate: self)
            view.backgroundColor = .red
            self.photoImageView.image = UIImage(named: "lockError")
            if self.isCancelButton == true {
                submessageLabel.text = "Codes don't match. Please try again".localized()
            }else{
                submessageLabel.text = "Wrong passcode, please try again".localized()
            }
            
        }
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    fileprivate func clearView() {
        pin = ""
        pinIndicators.forEach { view in
            view.isNeedClear = false
            UIView.animate(withDuration: ALConstants.duration, animations: {
                view.backgroundColor = .clear
            })
        }
    }
    
    // MARK: - Touch ID / Face ID
    fileprivate func checkSensors() {
        guard mode == .validate else {return}
        
        if faceIDAvailable() {
            
            ALConstants.kLocalizedReason = "Unlock with Face ID"
            
        }else {
            
            ALConstants.kLocalizedReason = "Unlock with Touch ID"
            
        }
        //Create a context
        let authenticationContext = LAContext()
        var error:NSError?
        
        //Check if device have Biometric sensor
        let isValidSensor : Bool = authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if isValidSensor {
            //Device have BiometricSensor
            //It Supports TouchID
            
            authenticationContext.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: ALConstants.kLocalizedReason,
                reply: { [unowned self] (success, error) -> Void in
                    
                    if(success) {
                        // Touch / Face ID recognized success here
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                            self.delegate.closePinCodeView(typeClose: .validate)
                        }
                    } else {
                        //If not recognized then
                        if let error = error {
                            let strMessage = self.errorMessage(errorCode: error._code)
                            if strMessage != ""{
                                DispatchQueue.main.async {
                                    self.showAlertWithTitle(title: Localize.error(), message: strMessage)
                                }
                            }
                        }
                    }
            })
        } else {
            
            let strMessage = self.errorMessage(errorCode: (error?._code)!)
            if strMessage != ""{
                DispatchQueue.main.async {
                    self.showAlertWithTitle(title: Localize.error(), message: strMessage)
                }
            }
        }
    }
    
    // MARK: - Keyboard
    @IBAction func keyboardPressed(_ sender: UIButton) {
        switch sender.tag {
        case ALConstants.button.delete.rawValue:
            drawing(isNeedClear: true)
        case ALConstants.button.cancel.rawValue:
            clearView()
            if isCancelButton == false{
                self.logout(sender)
            }else{
                self.dismiss(animated: true)
                delegate.closePinCodeView(typeClose: .cancel)
            }
        default:
            drawing(isNeedClear: false, tag: sender.tag)
        }
    }
    
}

// MARK: - CAAnimationDelegate
extension AppLocker: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        clearView()
    }
}

// MARK: - Present
public extension AppLocker {
    // Present AppLocker
    class func present(with mode: ALMode, and config: ALAppearance? = nil, withController: UIViewController) {
        
        guard let _ = UIApplication.shared.keyWindow?.rootViewController,
            
            let locker = Bundle(for: self.classForCoder()).loadNibNamed(ALConstants.nibName, owner: self, options: nil)?.first as? AppLocker else {
                print()
                
                return
        }
        //    if mode == .validate {
        //        if locker.savedPin == "" || locker.savedPin == nil  {
        //            return
        //        }
        //    }
        if (config?.cancelIsVissible)! == false{
            locker.cancelButton.setTitle("Log out".localized(), for: .normal)
        }
        locker.messageLabel.text = config?.title ?? ""
        locker.vc = withController
        locker.submessageLabel.text = config?.subtitle ?? ""
        locker.view.backgroundColor = config?.color ?? .black
        locker.mode = mode
        locker.isCancelButton = config?.cancelIsVissible
        locker.delegate = config?.delegate
        if config?.isSensorsEnabled ?? false {
            if UserDefaults.standard.bool(forKey: "isWithTouchID"){
                locker.checkSensors()
            }
        }
        
        if let image = config?.image {
            locker.photoImageView.image = image
        } else {
            locker.photoImageView.isHidden = true
        }
        locker.modalPresentationStyle = .fullScreen
        withController.present(locker, animated: true, completion: nil)
    }
}

extension AppLocker {
    //MARK: TouchID error
    func errorMessage(errorCode:Int) -> String{
        
        var strMessage = ""
        
        switch errorCode {
            
        case LAError.Code.authenticationFailed.rawValue:
            strMessage = "Authentication Failed"
            
        case LAError.Code.userCancel.rawValue:
            strMessage = "User Cancel"
            
        case LAError.Code.systemCancel.rawValue:
            strMessage = "System Cancel"
            
        case LAError.Code.passcodeNotSet.rawValue:
            strMessage = "Please go to the Settings & Turn On Passcode"
            
        case LAError.Code.touchIDNotAvailable.rawValue:
            strMessage = "TouchI or FaceID Dont Available"
            
        case LAError.Code.touchIDNotEnrolled.rawValue:
            strMessage = "TouchID or FaceID Not Enrolled"
            
        case LAError.Code.touchIDLockout.rawValue:
            strMessage = "TouchID or FaceID Lockout Please goto the Settings & Turn On Passcode"
            
        case LAError.Code.appCancel.rawValue:
            strMessage = "App Cancel"
            
        case LAError.Code.invalidContext.rawValue:
            strMessage = "Invalid Context"
            
        default:
            strMessage = ""
            
        }
        return strMessage
    }
    
    //MARK: Show Alert
    func showAlertWithTitle( title:String, message:String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
}
