//
//  MQRViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MQRViewController: HSScanViewController {
    
    lazy var qrViewModel: QRViewModel = {
        return QRViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.scanCodeTypes  = [.qr]
        
        qrViewModel.authorizeToken = { [weak self] in
            DispatchQueue.main.async {
                
                self?.scanWorker.start()
                
            }
        }
        
    }
    
}

extension MQRViewController: HSScanViewControllerDelegate{
    
    func scanFinished(scanResult: ScanResult, error: String?) {
        
        if let data = scanResult.scanResultString?.data(using: .utf8) {
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
                {
                    if jsonArray["type"] as! String == "auth_token"{
                        self.scanWorker.stop()
                        self.showSimpleAlertWithAction(title: "Login QR",
                                                       message: "You sure you wan't to login this device?".localized(),
                                                       okAction: UIAlertAction(title: "YES", style: .default, handler: { (action) in
                                                        
                                                        self.qrViewModel.initAuthorizeToken(token: jsonArray["value"] as! String)
                            
                                                       }),
                                                       cancelAction: UIAlertAction(title: "NO", style: .default, handler: { (action) in
                                                        
                                                        self.scanWorker.start()
                                                       }))
                        
                        
                    }
                }
            } catch {
                showSimpleToast(message: "Unknown QR-code!")
            }
        }
        
        
    }
}
