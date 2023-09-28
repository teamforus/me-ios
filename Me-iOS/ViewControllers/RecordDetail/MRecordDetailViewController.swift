//
//  MRecordDetailViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/27/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Rswift

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
    private let tableView: TableView_Background_DarkMode = {
        let tableView = TableView_Background_DarkMode(frame: .zero)
        tableView.colorName = "Background_Voucher_DarkTheme"
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
        if #available(iOS 11.0, *) {
            self.view.backgroundColor = UIColor(named: "Background_DarkTheme")
        } else {}
        addSubviews()
        setupConstraints()
        setupTableView()
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
    
    private func setupTableView() {
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        tableView.register(ValidatorTableViewCell.self, forCellReuseIdentifier: ValidatorTableViewCell.reuseIdentifier)
        tableView.register(RecordInfoTableViewCell.self, forCellReuseIdentifier: RecordInfoTableViewCell.reuseIdentifier)
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
    
    @objc func showQRCode() {
        self.navigator.navigate(to: .openQRRecord(self.record, vc: self))
    }
    
    @IBAction func deleteRecord(_ sender: UIButton) {
        KVSpinnerView.show()
        recordDetailViewModel.initDeleteById(id: String(record.id ?? 0))
    }
}

extension MRecordDetailViewController {
    // MARK: - Add Subviews
    private func addSubviews() {
        self.view.addSubview(tableView)
    }
}

extension MRecordDetailViewController {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.bottom.equalTo(view)
        }
    }
}
