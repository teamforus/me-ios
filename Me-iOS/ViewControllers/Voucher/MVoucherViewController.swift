//
//  MVoucherViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SafariServices

enum VoucherTableViewSection: Int, CaseIterable {
    case voucher = 0
    case infoVoucher
    case activeDate
    case transactions
}

class MVoucherViewController: UIViewController {

    var dataSource: VoucherDataSource!
    lazy var voucherViewModel: VoucherViewModel = {
        return VoucherViewModel()
    }()
    var address: String!
    var voucher: Voucher
    var navigator: Navigator
    
    // MARK: - Properties
    private let tableView: TableView_Background_DarkMode = {
        let tableView = TableView_Background_DarkMode(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
//        tableView.colorName = "Background_Voucher_DarkTheme"
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private let emptyLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.text = Localize.transcation_empty()
        return label
    }()
    
    // MARK: - Init
    init(voucher: Voucher, navigator: Navigator) {
        self.voucher = voucher
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup View
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        if #available(iOS 11.0, *) {
            self.view.backgroundColor = UIColor(named: "Background_Voucher_DarkTheme")
        } else {}
        setupSubview()
        setUpTableView()
        
        voucherViewModel.initFetchById(address: voucher.address ?? String.empty)
        
        voucherViewModel.reloadDataVoucher = { [weak self] (voucher, transactions) in
            guard let self = self else { return }
            
            self.dataSource = VoucherDataSource(voucher: voucher, parentViewController: self, navigator: self.navigator, transaction: transactions, voucherViewModel: self.voucherViewModel)
            
            DispatchQueue.main.async {
                self.emptyLabel.isHidden = transactions.count != 0
                self.setUpTableView()
            }
        }
        
        
    }
    
    private func setUpTableView() {
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.register(MProductVoucherTableViewCell.self, forCellReuseIdentifier: MProductVoucherTableViewCell.identifier)
        tableView.register(MInfoVoucherTableViewCell.self, forCellReuseIdentifier: MInfoVoucherTableViewCell.identifier)
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.identifier)
        tableView.register(ActiveDateVoucherTableViewCell.self, forCellReuseIdentifier: ActiveDateVoucherTableViewCell.identifier)
        self.tableView.reloadData()
    }
}

extension MVoucherViewController{
    // MARK: - Setup Subview
    func setupSubview() {
        self.view.addSubview(tableView)
        self.view.addSubview(emptyLabel)
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}


