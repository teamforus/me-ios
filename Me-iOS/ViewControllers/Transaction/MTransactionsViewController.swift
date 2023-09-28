//
//  MTransactionsViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 29.08.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MTransactionsViewController: UIViewController {
    
    lazy var transactionViewModel: TransactionViewModel = {
        let viewModel = TransactionViewModel()
        viewModel.vc = self
        return viewModel
    }()
    
    private var transaction: [Transaction] = []
    private let cellHeight: CGFloat = 89
    
    // MARK: - Properties
    private let headerView: Background_DarkMode = {
        let view = Background_DarkMode()
        view.colorName = "DarkGray_DarkTheme"
        return view
    }()
    
    private let dateButton: ShadowButton = {
        let button = ShadowButton()
        button.addTarget(self, action: #selector(openDatePicker), for: .touchUpInside)
        button.corner = 9
        button.colorName = "VoucherButton"
        button.colorNameTitle = "Blue_DarkTheme"
        button.titleLabel?.font = R.font.googleSansRegular(size: 14)
        return button
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
        view.isHidden = true
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
    
    lazy var datePicker : MDatePickerView = {
        let mdate = MDatePickerView()
        mdate.Color = #colorLiteral(red: 0.1702004969, green: 0.3387943804, blue: 1, alpha: 1)
        mdate.delegate = self
        mdate.translatesAutoresizingMaskIntoConstraints = false
        mdate.from = 2016
        mdate.to = 2100
        return mdate
    }()
    
  lazy var datePickerNew : UIDatePicker = {
      let mdate = UIDatePicker()
      mdate.translatesAutoresizingMaskIntoConstraints = false
      if #available(iOS 14.0, *) {
        mdate.backgroundColor = .clear
        mdate.preferredDatePickerStyle = .compact
        mdate.datePickerMode = .date
        mdate.addTarget(self, action: #selector(getDate(from:)), for: .valueChanged)
        } else {
        // Fallback on earlier versions
      }
     return mdate
  }()
   
  var gestorRecognizer = UIGestureRecognizer()
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        addSubviews()
        setupConstraints()
        setupView()
    }
    
}

// MARK: - Setup View

extension MTransactionsViewController {
    func setupView() {
        dateButton.setTitle(Localize.choose_from_date(), for: .normal)
        if #available(iOS 11.0, *) {
            self.view.backgroundColor = UIColor(named: "Background_DarkTheme")
        } else {
        }
        setupTableView()
        fetchTransaction()
        fetchComplete()
    }
    
    func addSubviews() {
        let views = [tableView, headerView, bottomView, totalPriceView, dateButton]
        views.forEach { (view) in
            self.view.addSubview(view)
        }
        addBottomViewSubviews()
      if #available(iOS 14.0, *) {
//        view.addSubview(datePickerNew)
        } else {
         
      }
     
    }
    
    func addBottomViewSubviews() {
        let views = [topLineView, bottomLineView, totalLabel, priceTotalLabel]
        views.forEach { (view) in
            self.totalPriceView.addSubview(view)
        }
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(TransactionListTableViewCell.self, forCellReuseIdentifier: TransactionListTableViewCell.identifier)
    }
}

// MARK: - Setup Constraints

extension MTransactionsViewController {
    func setupConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(dateButton.snp.bottom)
        }
        
        dateButton.snp.makeConstraints { make in
            make.left.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.height.equalTo(44)
            make.width.equalTo(200)
        }
        
//        NSLayoutConstraint.activate([
//            totalPriceView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 18),
//            totalPriceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//            totalPriceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//            totalPriceView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -28),
//            totalPriceView.heightAnchor.constraint(equalToConstant: 50)
//        ])
//
//        NSLayoutConstraint.activate([
//            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
//            bottomView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0)])
        
       
        setupConstraintsBottomView()
    }
    
    func setupConstraintsBottomView() {
        topLineView.snp.makeConstraints { make in
            make.top.left.right.equalTo(totalPriceView)
            make.height.equalTo(1)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.centerY.equalTo(totalPriceView)
            make.left.equalTo(totalPriceView).offset(24)
        }
        
        priceTotalLabel.snp.makeConstraints { make in
            make.centerY.equalTo(totalPriceView)
            make.right.equalTo(totalPriceView).offset(-24)
        }
        
        bottomLineView.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(totalPriceView)
            make.height.equalTo(1)
        }
    }
}

// MARK: - Fetch Transaction

extension MTransactionsViewController {
    func fetchTransaction() {
        if isReachable() {
            KVSpinnerView.show()
            transactionViewModel.vc = self
            transactionViewModel.initFetch()
        }else {
            showInternetUnable()
        }
    }
    
    func fetchComplete() {
        transactionViewModel.complete = { [weak self] (_) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                KVSpinnerView.dismiss()
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension MTransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionListTableViewCell.identifier, for: indexPath) as? TransactionListTableViewCell else { return UITableViewCell() }
        
        let transaction = transactionViewModel.getCellViewModel(at: indexPath)
        cell.configure(transaction: transaction)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = transactionViewModel.getCellViewModel(at: indexPath)
        openTransactionOverview(with: transaction)
        
    }
}

// MARK: - MDatePickeDelegate

extension MTransactionsViewController: MDatePickerViewDelegate {
    func mdatePickerView(selectDate: Date) {
      dateButton.setTitle("From date: " + selectDate.dateFormaterFromDateShort(), for: .normal)
        transactionViewModel.sortTransactionByDate(form: selectDate)
    }
}

// MARK: - Actions

extension MTransactionsViewController {
    func openTransactionOverview(with transaction: Transaction) {
        let transactionOverview = TransactionOverview()
        setupTrasactionOverview(transactionOverview: transactionOverview)
        transactionOverview.configure(transaction: transaction)
        transactionOverview.popIn()
    }
    
    func setupTrasactionOverview(transactionOverview: TransactionOverview) {
        transactionOverview.backgroundColor = .clear
        self.view.addSubview(transactionOverview)
        transactionOverview.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(self.view)
        }
    }
    
     @objc func openDatePicker() {
        view.addSubview(datePicker)
        setupDatePickerConstraints()
        datePicker.showAnimate()
    }
    
    func setupDatePickerConstraints() {
        datePicker.snp.makeConstraints { make in
            make.center.equalTo(self.view)
            make.width.equalTo(self.view).multipliedBy(0.7)
            make.height.equalTo(self.view).multipliedBy(0.4)
        }
    }
  
  
  @objc func getDate(from datePiker:UIDatePicker) {
    dateButton.setTitle("From date: " + datePiker.date.dateFormaterFromDateShort(), for: .normal)
    transactionViewModel.sortTransactionByDate(form: datePiker.date)
    self.dismiss(UIButton())
  }
}
