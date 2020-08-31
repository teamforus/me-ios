//
//  MTransactionsViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 29.08.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MTransactionsViewController: UIViewController {
    
    private let headerView: Background_DarkMode = {
        let view = Background_DarkMode()
        view.colorName = "WhiteBackground_DarkTheme"
        return view
    }()
    
    private let backButton: BackButton_DarkMode = {
        let button = BackButton_DarkMode()
        return button
    }()
    
    private let titleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode()
        label.text = "Transacties"
        label.font = UIFont(name: "GoogleSans-Medium", size: 38)
        return label
    }()
    
    private let tableView: TableView_Background_DarkMode = {
        let tableView = TableView_Background_DarkMode()
        return tableView
    }()
    
    private let bottomView: Background_DarkMode = {
        let view = Background_DarkMode()
        view.colorName = "Background_DarkTheme"
        return view
    }()
    
    private let totalPriceView: Background_DarkMode = {
        let view = Background_DarkMode()
        view.colorName = "Background_DarkTheme"
        return view
    }()
    
    private let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let totalLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode()
        label.text = "Totaal"
        label.font = UIFont(name: "GoogleSans-Regular", size: 15)
        return label
    }()
    
    private let priceTotalLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode()
        label.textColor = #colorLiteral(red: 0.1702004969, green: 0.3387943804, blue: 1, alpha: 1)
        label.text = "€ 2.008,09"
        label.font = UIFont(name: "GoogleSans-Regular", size: 15)
        return label
    }()
    
    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    var transactionOverview: TransactionOverview = {
        let view = TransactionOverview()
        view.isHidden = true
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var voucherViewModel: VouchersViewModel = {
        return VouchersViewModel()
    }()
    
    private var transaction: [Transaction] = []
    private let cellHeight: CGFloat = 89
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addHeaderViewSubviews()
        addBottomViewSubviews()
        setupView()
        setupTableView()
        fetchTransaction()
        fetchComplete()
    }
    
}

// MARK: - Setup View

extension MTransactionsViewController {
    func setupView() {
        setupConstraints()
        setupConstraintsHeaderView()
        setupConstraintsBottomView()
    }
    
    func addSubviews() {
        let views = [headerView, tableView, bottomView, totalPriceView, transactionOverview]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
    }
    
    func addHeaderViewSubviews() {
        let views = [backButton, titleLabel]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.headerView.addSubview(view)
        }
    }
    
    func addBottomViewSubviews() {
        let views = [topLineView, bottomLineView, totalLabel, priceTotalLabel]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.totalPriceView.addSubview(view)
        }
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.identifier)
    }
}

// MARK: - Setup Constraints

extension MTransactionsViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            headerView.heightAnchor.constraint(equalToConstant: 154),
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            totalPriceView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 18),
            totalPriceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            totalPriceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            totalPriceView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -28),
            totalPriceView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            bottomView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0)])
        
        NSLayoutConstraint.activate([
            transactionOverview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            transactionOverview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            transactionOverview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            transactionOverview.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)])
    }
    
    func setupConstraintsHeaderView() {
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 90),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 17)
        ])
    }
    
    func setupConstraintsBottomView() {
        NSLayoutConstraint.activate([
            topLineView.topAnchor.constraint(equalTo: totalPriceView.topAnchor, constant: 0),
            topLineView.leadingAnchor.constraint(equalTo: totalPriceView.leadingAnchor, constant: 0),
            topLineView.trailingAnchor.constraint(equalTo: totalPriceView.trailingAnchor, constant: 0),
            topLineView.heightAnchor.constraint(equalToConstant: 1)
            
        ])
        
        NSLayoutConstraint.activate([
            totalLabel.centerYAnchor.constraint(equalTo: totalPriceView.centerYAnchor, constant: 0),
            totalLabel.leadingAnchor.constraint(equalTo: totalPriceView.leadingAnchor, constant: 24)
        ])
        
        NSLayoutConstraint.activate([
            priceTotalLabel.centerYAnchor.constraint(equalTo: totalPriceView.centerYAnchor, constant: 0),
            priceTotalLabel.trailingAnchor.constraint(equalTo: totalPriceView.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            bottomLineView.bottomAnchor.constraint(equalTo: totalPriceView.bottomAnchor, constant: 0),
            bottomLineView.leadingAnchor.constraint(equalTo: totalPriceView.leadingAnchor, constant: 0),
            bottomLineView.trailingAnchor.constraint(equalTo: totalPriceView.trailingAnchor, constant: 0),
            bottomLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

// MARK: - Fetch Transaction

extension MTransactionsViewController {
    func fetchTransaction() {
        if isReachable() {
            KVSpinnerView.show()
            voucherViewModel.vc = self
            voucherViewModel.initFetch()
        }else {
            showInternetUnable()
        }
    }
    
    func fetchComplete() {
        voucherViewModel.complete = { [weak self] (vouchers) in
            DispatchQueue.main.async {
                self?.sortTransaction(vouchers: vouchers)
                self?.tableView.reloadData()
                KVSpinnerView.dismiss()
            }
        }
    }
    
    func sortTransaction(vouchers: [Voucher]) {
        vouchers.forEach { (voucher) in
            voucher.transactions?.forEach({ (transaction) in
                self.transaction.append(transaction)
            })
        }
    }
}

// MARK: - UITableViewDelegate

extension MTransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as? TransactionTableViewCell else { return UITableViewCell() }
        cell.transaction = transaction[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}
