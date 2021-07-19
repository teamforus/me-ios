//
//  MRecordDetailViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/27/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MRecordDetailViewController: UIViewController {
    
    var navigator: Navigator
    var timer : Timer! = Timer()
    var record: Record
    lazy var recordDetailViewModel: RecordDetailViewModel = {
        return RecordDetailViewModel()
    }()
    private lazy var qrViewModel: QRViewModel = {
        return QRViewModel()
    }()
    var dataSource: RecordDetailDataSource
    
    // MARK: - Parameters
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    
    // MARK: - Init
    init(navigator: Navigator, record: Record) {
        self.navigator = navigator
        self.record = record
        self.dataSource = RecordDetailDataSource(record: record)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup View
    override func viewDidLoad() {
        super.viewDidLoad()
        recordDetailViewModel.vc = self
        fetchRecordDetail()
        completeDelete()
        setupTimer()
    }
    
    deinit {
        self.timer.invalidate()
        self.timer = nil
    }
    
    func setupTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(self.checkRecordValidateState), userInfo: nil, repeats: true)
    }
    
    @objc func checkRecordValidateState() {
        fetchRecordValidationState()
    }
    
    func fetchRecordValidationState() {
        if let recordValue = UserDefaults.standard.string(forKey: UserDefaultsName.CurrentRecordUUID) {
            self.qrViewModel.initValidationRecord(code: recordValue)
        }
        
        qrViewModel.validateRecord = { [weak self] (recordValidation, statusCode) in
            
            DispatchQueue.main.async {
                
                if statusCode != 503 {
                    if recordValidation.state == "approved" {
                        self?.showSimpleAlert(title: Localize.success(), message: Localize.validation_approved())
                    }
                }else {}
            }
        }
    }
    
    func fetchRecordDetail() {
        recordDetailViewModel.complete = { [weak self] (record) in
            
            DispatchQueue.main.async {
                
                self?.record = record
                self?.tableView.reloadData()
                self?.tableView.isHidden = record.validations?.count == 0
                KVSpinnerView.dismiss()
            }
        }
        
        if isReachable() {
            KVSpinnerView.show()
            recordDetailViewModel.initFetchById(id: String(record.id ?? 0))
        }else {
            showInternetUnable()
        }
    }
    
    func completeDelete() {
        recordDetailViewModel.completeDelete = { [weak self] (statusCode) in
            DispatchQueue.main.async {
                KVSpinnerView.dismiss()
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func showQRCode() {
        let popOverVC = PullUpQRViewController(nib: R.nib.pullUpQRViewController)
        popOverVC.idRecord = Int(record.id ?? 0)
        popOverVC.record = record
        popOverVC.qrType = .Record
        showPopUPWithAnimation(vc: popOverVC)
    }
    
    @IBAction func deleteRecord(_ sender: UIButton) {
        KVSpinnerView.show()
        recordDetailViewModel.initDeleteById(id: String(record.id ?? 0))
    }
}
