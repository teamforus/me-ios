//
//  MQRViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import KVSpinnerView

enum QRTypeScann: String {
    case authToken = "auth_token"
    case voucher = "voucher"
    case record = "record"
    case testTransaction = "demo_voucher"
}

class MQRViewController: HSScanViewController {
    
    private lazy var qrViewModel: QRViewModel = {
        return QRViewModel()
    }()
    private var voucher: Voucher!
    private var testToken: String!
    private var productVoucher: [Transaction]! = []
    
    private var recordValidateResponse: RecordValidation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.scanCodeTypes  = [.qr]
        
        qrViewModel.vc = self
        qrViewModel.vcAlert = self
        
        qrViewModel.authorizeToken = { [weak self] (statusCode) in
            DispatchQueue.main.async {
                KVSpinnerView.dismiss()
                if statusCode != 503 {
                    
                    self?.scanWorker.start()
                    
                }else {
                    
                    self?.showErrorServer()
                }
            }
        }
        
        qrViewModel.validateRecord = { [weak self] (recordValidation, statusCode) in
            
            DispatchQueue.main.async {
                
                if statusCode != 503 {
                    KVSpinnerView.dismiss()
                    self?.qrViewModel.getOrganizations()
                    self?.recordValidateResponse = recordValidation
                    
                }else {
                    KVSpinnerView.dismiss()
                    self?.showErrorServer()
                    
                }
            }
        }
        
        qrViewModel.completeOrganization = { [unowned self] (organizations) in
            DispatchQueue.main.async {
                if organizations.count != 0 {
                    let popOverVC = OrganizationValidatorViewController(nibName: "OrganizationValidatorViewController", bundle: nil)
                    popOverVC.recordEmployeesOrganizations = organizations
                    popOverVC.delegate = self
                    self.tabBarController?.addChild(popOverVC)
                    popOverVC.view.frame = CGRect(x: 0, y: 0, width: (self.tabBarController?.view.frame.size.width)!, height: (self.tabBarController?.view.frame.size.height)!)
                    self.tabBarController?.view.addSubview(popOverVC.view)
                }else {
                    self.qrViewModel.initApproveValidationRecord(code: self.recordValidateResponse.uuid ?? "", organization:  OrganizationRecord(organization_id:  0))
                }
                
            }
        }
        
        qrViewModel.validateApproveRecord = { [weak self] (statusCode) in
            
            DispatchQueue.main.async {
                
                if statusCode != 503 {
                    KVSpinnerView.dismiss()
                    if statusCode != 401 {
                        
                        self?.showSimpleAlertWithSingleAction(title: "Success".localized(), message: "A record has been validated!".localized(),
                                                              okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                                                self?.scanWorker.start()
                                                              }))
                    }else {
                        KVSpinnerView.dismiss()
                        self?.showErrorServer()
                        
                    }
                }
            }
        }
        
        qrViewModel.getVoucher = { [weak self] (voucher, statusCode) in
            
            DispatchQueue.main.async {
                
                if statusCode != 503 {
                    KVSpinnerView.dismiss()
                    if statusCode != 403 {
                        
                        if voucher.amount != "0.00" {
                            
                            self?.voucher = voucher
                            
                            if voucher.allowed_organizations?.count != 0 && voucher.allowed_organizations?.count  != nil {
                                
                                if voucher.product_vouchers?.count != 0 {
                                    voucher.product_vouchers?.forEach({ (voucherToken) in
                                        if voucherToken.product?.organization_id == voucher.allowed_organizations?.first?.id {
                                            self?.productVoucher.append(voucherToken)
                                        }
                                    })
                                    if self?.productVoucher.count != 0 {
                                        self?.performSegue(withIdentifier: "goToChooseProduct", sender: nil)
                                    }else {
                                        self?.performSegue(withIdentifier: "goToVoucherPayment", sender: nil)
                                    }
                                }else {
                                    
                                    self?.performSegue(withIdentifier: "goToVoucherPayment", sender: nil)
                                }
                                
                            }else if voucher.product != nil{
                                
                                if voucher.product?.price != "0.00"{
                                    
                                    self?.performSegue(withIdentifier: "goToVoucherPayment", sender: nil)
                                }else{
                                    
                                    self?.showSimpleAlertWithSingleAction(title: "Error!".localized(),
                                                                          message: "This product voucher is used!".localized(),
                                                                          okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                                                            self?.scanWorker.start()
                                                                          }))
                                }
                                
                            }else {
                                
                                self?.showSimpleAlertWithSingleAction(title: "Error!".localized(),
                                                                      message: "Sorry you do not meet the criteria for this voucher".localized(),
                                                                      okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                                                        self?.scanWorker.start()
                                                                      }))
                            }
                        }else {
                            
                            self?.showSimpleAlertWithSingleAction(title: "Error!".localized(),
                                                                  message: "The voucher is empty! No transactions can be done.".localized(),
                                                                  okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                                                    self?.scanWorker.start()
                                                                  }))
                        }
                    }else {
                        
                        self?.showSimpleAlertWithSingleAction(title: "Error!".localized(), message: "You can't scan this voucher. You are not accepted as a provider for the fund that hands out these vouchers.".localized(), okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            self?.scanWorker.start()
                        }))
                    }
                    
                    //                    self?.scanWorker.start()
                    
                }else {
                    KVSpinnerView.dismiss()
                    self?.showErrorServer()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13, *) {
        }else {
            self.setStatusBarStyle(.lightContent)
        }
        if scanWorker != nil {
            scanWorker.start()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToVoucherPayment" {
            if let paymentVC = segue.destination as? MPaymentViewController {
                paymentVC.testToken = testToken
                paymentVC.voucher = voucher
                paymentVC.tabBar = self.tabBarController
                
            }
        }else if segue.identifier == "goToChooseProduct" {
            if let productReservation = segue.destination as? MProductReservationViewController {
                
                productReservation.voucher = voucher
                productReservation.voucherTokens = productVoucher.filter({$0.amount != "0.0"})
                productReservation.vc = self
                productReservation.tabBar = self.tabBarController
                
            }
        }
    }
    
}

extension MQRViewController: HSScanViewControllerDelegate{
    
    func scanFinished(scanResult: ScanResult, error: String?) {
        if isReachable() {
            
            
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
                                                           okAction: UIAlertAction(title: "YES".localized(), style: .default, handler: { (action) in
                                                            KVSpinnerView.show()
                                                            self.qrViewModel.initAuthorizeToken(token: qr.value)
                                                            
                                                           }),
                                                           cancelAction: UIAlertAction(title: "NO".localized(), style: .cancel, handler: { (action) in
                                                            
                                                            self.scanWorker.start()
                                                           }))
                            
                            
                        } else if qr.type == QRTypeScann.voucher.rawValue {
                            
                            self.scanWorker.stop()
                            KVSpinnerView.show()
                            self.qrViewModel.initVoucherAddress(address: qr.value)
                            
                            
                        } else if qr.type == QRTypeScann.record.rawValue {
                            
                            self.scanWorker.stop()
                            KVSpinnerView.show()
                            self.qrViewModel.initValidationRecord(code: qr.value)
                            
                        } else if qr.type == QRTypeScann.testTransaction.rawValue {
                            self.scanWorker.stop()
                            self.testToken = qr.value
                            self.performSegue(withIdentifier: "goToVoucherPayment", sender: nil)
                        }
                    }
                } catch {
                    KVSpinnerView.dismiss()
                    showSimpleToast(message: "Unknown QR-code!")
                }
            }
        }else {
            
            self.scanWorker.start()
            showInternetUnable()
        }
        
        
    }
}

extension MQRViewController: OrganizationValidatorViewControllerDelegate {
    
    func close() {
        self.scanWorker.start()
    }
    
    func selectOrganization(organization: EmployeesOrganization) {
        self.showSimpleAlertWithAction(title: self.recordValidateResponse.name ?? "", message: self.recordValidateResponse.value ?? "",
                                       okAction: UIAlertAction(title: "Validate".localized(), style: .default, handler: { (action) in
                                        
                                        self.qrViewModel.initApproveValidationRecord(code: self.recordValidateResponse.uuid ?? "", organization:  OrganizationRecord(organization_id: organization.organization_id ?? 0))
                                       }),
                                       cancelAction: UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: { (action) in
                                        self.scanWorker.start()
                                       }))
    }
}
