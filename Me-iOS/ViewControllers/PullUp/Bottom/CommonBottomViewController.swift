//
//  MLoginBottomViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import ISHPullUp

public enum QRType{
    case AuthToken
    case Voucher
    case Record
}

class CommonBottomViewController: UIViewController {
    
    @IBOutlet private weak var handleView: ISHPullUpHandleView!
    @IBOutlet private weak var rootView: UIView!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    
    var timer : Timer! = Timer()
    private var firstAppearanceCompleted = false
    var token: String!
    weak var pullUpController: ISHPullUpViewController!
    private var halfWayPoint = CGFloat(0)
    var qrType: QRType! = QRType.AuthToken
    lazy var bottomQRViewModel: CommonBottomViewModel! = {
        return CommonBottomViewModel()
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(toglePullUpView), name: NotificationName.TogleStateWindow, object: nil)
        
        switch qrType {
        case .AuthToken?:
            
            bottomQRViewModel.completeToken = { [weak self] (token, accessToken) in
                
                DispatchQueue.main.async {
                    
                    self?.qrCodeImageView.generateQRCode(from: "{ \"type\": \"auth_token\",\"value\": \"\(token)\" }")
                    self?.timer = Timer.scheduledTimer(timeInterval: 10, target: self!, selector: #selector(self?.checkAuthorizeToken), userInfo: nil, repeats: true)
                    self?.token = accessToken
                    
                }
            }
            
            bottomQRViewModel.initFetchQrToken()
            
            break
        case .Voucher?:
            
            bottomQRViewModel.completeVoucher = { [weak self] (token) in
                
                self?.qrCodeImageView.generateQRCode(from: "{ \"type\": \"voucher\",\"value\": \"\(token)\" }")
            }
            
            break
        case .Record?:
            
            bottomQRViewModel.completeRecord = { [weak self] (token) in
                
                self?.qrCodeImageView.generateQRCode(from: "{ \"type\": \"record\",\"value\": \"\(token)\" }")
            }
            
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
                    UserDefaults.standard.set(self?.token, forKey: "TOKEN")
                    UserDefaults.standard.synchronize()
                     NotificationCenter.default.post(name: NotificationName.LoginQR, object: nil)
                }
            }
            
        }
        bottomQRViewModel.initAuthorizeToken(token: token)
        
    }
    
    @objc func toglePullUpView(){
        if pullUpController.state == .expanded{
            self.view.isHidden = true
        }else{
            self.view.isHidden = false
        }
        pullUpController.toggleState(animated: true)
    }
    
    @IBAction func close(_ sender: Any) {
        if pullUpController.state == .expanded || pullUpController.state == .intermediate{
            pullUpController.toggleState(animated: true)
            self.view.isHidden = true
        }
    }
    
}

extension CommonBottomViewController: ISHPullUpStateDelegate, ISHPullUpSizingDelegate{
    
    // MARK: ISHPullUpSizingDelegate
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, maximumHeightForBottomViewController bottomVC: UIViewController, maximumAvailableHeight: CGFloat) -> CGFloat {
        let totalHeight = rootView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        halfWayPoint = totalHeight / 2.0
        return totalHeight
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, minimumHeightForBottomViewController bottomVC: UIViewController) -> CGFloat {
        return topView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height;
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, targetHeightForBottomViewController bottomVC: UIViewController, fromCurrentHeight height: CGFloat) -> CGFloat {
        if abs(height - halfWayPoint) < 30 {
            return halfWayPoint
        }
        return height
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, update edgeInsets: UIEdgeInsets, forBottomViewController bottomVC: UIViewController) {
    }
    
    // MARK: ISHPullUpStateDelegate
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, didChangeTo state: ISHPullUpState) {
        handleView.setState(ISHPullUpHandleView.handleState(for: state), animated: firstAppearanceCompleted)
        if state == .collapsed {
            self.view.isHidden = true
        }else if state == .intermediate {
            pullUpController.toggleState(animated: true)
        }
    }
    
}
