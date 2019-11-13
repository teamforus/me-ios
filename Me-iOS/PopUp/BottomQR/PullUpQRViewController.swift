//
//  PullUpQRViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 10/25/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

public enum QRType{
    case AuthToken
    case Voucher
    case Record
    case Profile
}

class PullUpQRViewController: UIViewController {
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var voucherNameLabel: UILabel!
    @IBOutlet weak var dateExpireLabel: UILabel!
    @IBOutlet weak var bodyView: CustomCornerUIView!
    @IBOutlet weak var titleDescriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var timer : Timer! = Timer()
    var token: String!
    var idRecord: Int!
    var qrType: QRType! = QRType.Profile
    lazy var bottomQRViewModel: CommonBottomViewModel! = {
        return CommonBottomViewModel()
    }()
    var voucher: Voucher!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyView.roundCorners(corners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 9)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.bottomConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch qrType {
        case .AuthToken?:
            
            bottomQRViewModel.completeToken = { [weak self] (token, accessToken) in
                
                DispatchQueue.main.async {
                    
                    self?.qrImage.generateQRCode(from: "{ \"type\": \"auth_token\",\"value\": \"\(token)\" }")
                    self?.timer = Timer.scheduledTimer(timeInterval: 7, target: self!, selector: #selector(self?.checkAuthorizeToken), userInfo: nil, repeats: true)
                    self?.token = accessToken
                    
                }
            }
            
            bottomQRViewModel.initFetchQrToken()
            
            break
        case .Voucher?:
            
            self.titleDescriptionLabel.text = "This is your Voucher’s QR-code.".localized()
            self.descriptionLabel.text = "Let the shopkeeper scan it to make a payment from your voucher.".localized()
            
            self.qrImage.generateQRCode(from: "{ \"type\": \"voucher\",\"value\": \"\(self.voucher.address ?? "")\" }")
            
            if voucher.product != nil {
                
                voucherNameLabel.text = voucher.product?.name ?? ""
                
            }else {
                
                voucherNameLabel.text = voucher.fund?.name ?? ""
                
            }
            
            dateExpireLabel.text = "This voucher expires on ".localized() + (voucher.expire_at?.date?.dateFormaterExpireDate())!
            
            break
        case .Record?:
            self.voucherNameLabel.isHidden = true
            self.dateExpireLabel.isHidden = true
            self.titleDescriptionLabel.text = "This is your personal QR code.".localized()
            self.descriptionLabel.text = "Let the shopkeeper scan it to make a validtion to your record.".localized()
            
            bottomQRViewModel.completeRecord = { [weak self] (record) in
                
                DispatchQueue.main.async {
                    
                    self?.qrImage.generateQRCode(from: "{ \"type\": \"record\",\"value\": \"\(record.uuid ?? "")\" }")
                    
                }
            }
            
            bottomQRViewModel.initFetchRecordToken(idRecords: idRecord)
            
            break
        case .Profile?:
            bottomQRViewModel.completeIdentity = { [weak self] (identityAddress) in
                
                DispatchQueue.main.async {
                    
                    self?.qrImage.generateQRCode(from: "{ \"type\": \"identity\",\"value\": \"\(identityAddress)\" }")
                    
                }
            }
            bottomQRViewModel.getIndentity()
            
            break
        default:
            break
        }
    }
    
    @objc func checkAuthorizeToken(){
        
        bottomQRViewModel.completeAuthorize = { [weak self] (message) in
            
            DispatchQueue.main.async {
                if message == "active"{
                    self?.timer.invalidate()
                    UserDefaults.standard.set(self?.token, forKey: UserDefaultsName.Token)
                    UserDefaults.standard.set(true, forKey: UserDefaultsName.UserIsLoged)
                    CurrentSession.shared.token = self?.token
                    UserDefaults.standard.synchronize()
                    NotificationCenter.default.post(name: NotificationName.LoginQR, object: nil)
                }
            }
            
        }
        bottomQRViewModel.initAuthorizeToken(token: token)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    @IBAction func closeQR(_ sender: Any) {
        closeQRAction()
    }
    
    @IBAction func closeGesture(_ sender: Any) {
        closeQRAction()
    }
    
    func closeQRAction(){
        self.bottomConstraint.constant = 439
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (isFinished) in
            self.view.removeFromSuperview()
        })
    }
    
}
