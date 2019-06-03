//
//  MQRViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

enum QRTypeScann: String {
    case authToken = "auth_token"
    case voucher = "voucher"
    case record = "record"
}

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
        
        qrViewModel.validateRecord = { [weak self] (recordValidation) in
            
            DispatchQueue.main.async {
                
                self?.showSimpleAlertWithAction(title: recordValidation.name ?? "", message: recordValidation.value ?? "",
                                            okAction: UIAlertAction(title: "Validate".localized(), style: .default, handler: { (action) in
                                                
                                                self?.qrViewModel.initApproveValidationRecord(code: recordValidation.uuid ?? "")
                                                
                                            }),
                                            cancelAction: UIAlertAction(title: "Cancel".localized(), style: .default, handler: { (action) in
                                                self?.scanWorker.start()
                                            }))
            }
            
        }
        
        qrViewModel.validateApproveRecord = { [weak self] (statusCode) in
            
            DispatchQueue.main.async {
                
                if statusCode != 401 {
                    
                    self?.showSimpleAlertWithSingleAction(title: "Success".localized(), message: "A record has been validated!".localized(),
                                                    okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                                        self?.scanWorker.start()
                                                    }))
                    
                }
                
            }
        }
        
    }
    
}

extension MQRViewController: HSScanViewControllerDelegate{
    
    func scanFinished(scanResult: ScanResult, error: String?) {
        
        if let data = scanResult.scanResultString?.data(using: .utf8) {
            let jsonDecoder = JSONDecoder()
            do {
                
                let qr = try jsonDecoder.decode(QRText.self, from: data)
                
                if qr.type != nil
                {
                    if qr.type == QRTypeScann.authToken.rawValue {
                        self.scanWorker.stop()
                        self.showSimpleAlertWithAction(title: "Login QR",
                                                       message: "You sure you wan't to login this device?".localized(),
                                                       okAction: UIAlertAction(title: "YES", style: .default, handler: { (action) in
                                                        
                                                        self.qrViewModel.initAuthorizeToken(token: qr.value)
                            
                                                       }),
                                                       cancelAction: UIAlertAction(title: "NO", style: .default, handler: { (action) in
                                                        
                                                        self.scanWorker.start()
                                                       }))
                        
                        
                    } else if qr.type == QRTypeScann.voucher.rawValue {
                        
                        self.scanWorker.stop()
                        
                        self.qrViewModel.initVoucherAddress(address: qr.value)
                        
                        
                    } else if qr.type == QRTypeScann.voucher.rawValue {
                        
                        self.scanWorker.stop()
                        
                        self.qrViewModel.initValidationRecord(code: qr.value)
                        
                    }
                }
            } catch {
                showSimpleToast(message: "Unknown QR-code!")
            }
        }
        
        
    }
}
