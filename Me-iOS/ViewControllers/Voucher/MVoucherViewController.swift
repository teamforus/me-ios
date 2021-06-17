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
    
    // MARK: - Properties
    private let tableView: TableView_Background_DarkMode = {
        let tableView = TableView_Background_DarkMode(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.colorName = "Background_Voucher_DarkTheme"
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    lazy var voucherViewModel: VoucherViewModel = {
        return VoucherViewModel()
    }()
    var address: String!
    var voucher: Voucher
    var navigator: Navigator
    
    
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
        setupUI()
    }
    
    private func setupUI() {
        
        fetchVoucher()
        setupVoucher()
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(MProductVoucherTableViewCell.self, forCellReuseIdentifier: MProductVoucherTableViewCell.identifier)
        tableView.register(MInfoVoucherTableViewCell.self, forCellReuseIdentifier: MInfoVoucherTableViewCell.identifier)
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.identifier)
    }
    
    private func fetchVoucher() {
        voucherViewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        if isReachable() {
            voucherViewModel.vc = self
            voucherViewModel.initFetchById(address: address)
        }else {
            showInternetUnable()
        }
    }
    
    private func setupVoucher() {
        voucherViewModel.reloadDataVoucher = { [weak self] (voucher) in
            
            DispatchQueue.main.async { [self] in
//                if voucher.fund?.type == FundType.subsidies.rawValue {
//                    self!.voucherInfoButton?.setTitle(Localize.offers(), for: .normal)
//                }
//                self?.priceLabel.isHidden = voucher.fund?.type == FundType.subsidies.rawValue
//                self?.voucherName.text = voucher.fund?.name ?? ""
//                self?.organizationName.text = voucher.fund?.organization?.name ?? ""
                
                if voucher.expire_at?.date?.formatDate() ?? Date() >= Date() {
                }
                self?.voucher = voucher
            }
        }
    }
    
    @IBAction func opendQR(_ sender: UIButton) {
        let popOverVC = PullUpQRViewController(nib: R.nib.pullUpQRViewController)
        popOverVC.voucher = voucher
        popOverVC.qrType = .Voucher
        showPopUPWithAnimation(vc: popOverVC)
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        
        voucherViewModel.completeSendEmail = { [weak self] (statusCode) in
            DispatchQueue.main.async {
                self?.showPopUPWithAnimation(vc: SuccessSendingViewController(nib: R.nib.successSendingViewController))
            }
        }
        
        showSimpleAlertWithAction(title: Localize.email_to_me(),
                                  message: Localize.send_voucher_to_your_email(),
                                  okAction: UIAlertAction(title: Localize.confirm(), style: .default, handler: { (action) in
                                    
                                    self.voucherViewModel.sendEmail(address: self.voucher.address ?? "")
                                    
                                  }),
                                  cancelAction: UIAlertAction(title: Localize.cancel(), style: .cancel, handler: nil))
    }
    
    @IBAction func info(_ sender: Any) {
        voucherViewModel.openVoucher()
        
        voucherViewModel.completeExchangeToken = { [weak self] (token) in
            
            DispatchQueue.main.async {
                if let urlWebShop = self?.voucher.fund!.url_webshop, let address = self?.voucher.address {
                    if let url = URL(string: urlWebShop + "auth-link?token=" + token + "&target=voucher-" + address) {
                        let safariVC = SFSafariViewController(url: url)
                        self?.present(safariVC, animated: true, completion: nil)
                    }
                }else {
                    if let url = URL(string: "https://kerstpakket.forus.io") {
                        let safariVC = SFSafariViewController(url: url)
                        self?.present(safariVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension MVoucherViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voucherViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TransactionTableViewCell
        
        let transaction = voucherViewModel.getCellViewModel(at: indexPath)
        return cell
    }
}

extension MVoucherViewController{
    
    func didAnimateTransactioList(){
        if voucherViewModel.numberOfCells > 8{
            if isFirstCellVisible(){
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }else{
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func isFirstCellVisible() -> Bool{
        let indexes = tableView.indexPathsForVisibleRows
        for indexPath in indexes!{
            if indexPath.row == 0{
                return true
            }
        }
        return false
    }
}


