//
//  MVoucherViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import StoreKit

enum VoucherType: Int {
    case valute = 0
    case vouchers = 1
}

class MVouchersViewController: UIViewController {
    var isFromLogin: Bool!
    var voucherType: VoucherType! = .vouchers
    var dataSource: VouchersDataSource!
    var wallet: Office!
    
    lazy var voucherViewModel: VouchersViewModel = {
        return VouchersViewModel()
    }()
    
    // MARK: - Properties
    private let refreshControl = UIRefreshControl()
    
    var segmentController: HBSegmentedControl!
    var segmentView: UIView!
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()
    
    var transactionButton: ActionButton = {
        let buttton = ActionButton(frame: .zero)
        buttton.setImage(Image.transactionIcon, for: .normal)
        return buttton
    }()
    
    var titleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansBold(size: 38)
        label.text = "Vouchers"
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        setupView()
    }
    
    private func setupView() {
        setupAccessibility()
        if !Preference.tapToSeeTransactionTipHasShown {
            Preference.tapToSeeTransactionTipHasShown = true
            transactionButton.toolTip(message: Localize.tap_here_you_want_to_see_list_transaction(), style: .dark, location: .bottom, offset: CGPoint(x: -50, y: 0))
        }
        
//        setupSegmentControll()
        voucherViewModel.completeIdentity = { [unowned self] (response) in
            DispatchQueue.main.async {
                self.wallet = response
            }
        }
        setupAction()
        voucherViewModel.getIndentity()
        setupTableView()
        initFetch()
        receiveFetch()
    }
    
    private func receiveFetch() {
        voucherViewModel.complete = { [weak self] (vouchers) in
            
            DispatchQueue.main.async {
                
                self?.voucherViewModel.sendPushToken(token: UserDefaults.standard.string(forKey: "TOKENPUSH") ?? "")
                self?.dataSource = VouchersDataSource(vouchers: vouchers, wallet: nil)
                self?.tableView.dataSource = self?.dataSource
                self?.tableView.delegate = self
                self?.tableView.reloadData()
                if vouchers.count == 0 {
                    
                    self?.tableView.isHidden = true
                }else {
                    
                    self?.tableView.isHidden = false
                }
                KVSpinnerView.dismiss()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    private func setupTableView() {
        registerForPreviewing(with: self, sourceView: tableView)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        tableView.separatorStyle = .none
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.register(VoucherTableViewCell.self, forCellReuseIdentifier: VoucherTableViewCell.identifier)
        
    }
    
    private func setupSegmentControll() {
        segmentController.items = ["Valute", Localize.vouchers()]
        segmentController.selectedIndex = 1
        segmentController.font = UIFont(name: "GoogleSans-Medium", size: 14)
        segmentController.unselectedLabelColor = #colorLiteral(red: 0.631372549, green: 0.6509803922, blue: 0.6784313725, alpha: 1)
        segmentController.selectedLabelColor = #colorLiteral(red: 0.2078431373, green: 0.3921568627, blue: 0.968627451, alpha: 1)
        segmentController.addTarget(self, action: #selector(self.segmentSelected(sender:)), for: .valueChanged)
        segmentController.borderColor = .clear
        segmentView.layer.cornerRadius = 8.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13, *) {
        }else {
            self.setStatusBarStyle(.default)
        }
    }
    
    func initFetch() {
        
        if isReachable() {
            
            KVSpinnerView.show()
            voucherViewModel.vc = self
            voucherViewModel.initFetch()
            
        }else {
            
            showInternetUnable()
        }
    }
    
    @objc func refreshData(_ sender: Any) {
        initFetch()
    }
    
    @objc func segmentSelected(sender:HBSegmentedControl) {
        
        switch sender.selectedIndex {
        case VoucherType.valute.rawValue:
            voucherType = .valute
            self.tableView.reloadData()
            self.tableView.isHidden = false
            break
        case VoucherType.vouchers.rawValue:
            voucherType = .vouchers
            if self.dataSource.vouchers.count == 0 {
                self.tableView.isHidden = true
            }else {
                self.tableView.isHidden = false
            }
            self.tableView.reloadData()
            break
        default: break
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
         if segue.identifier == "goToVoucher" {
            if let voucherVC = segue.destination as? MVoucherViewController {
                voucherVC.address = self.dataSource.vouchers[tableView.indexPathForSelectedRow?.row ?? 0].address
            }
        }
    }
}

extension MVouchersViewController: UITableViewDelegate{
    
    @objc func send(_ sender: UIButton) {
        self.showPopUPWithAnimation(vc: SendEtherViewController(nibName: "SendEtherViewController", bundle: nil))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let voucher = self.dataSource.vouchers[indexPath.row]
        
        switch voucherType {
        case .vouchers?:
            if voucher.product != nil {
                let vc = ProductVoucherViewController()
                vc.address = voucher.address ?? ""
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: nil)
            }else {
                self.performSegue(withIdentifier: "goToVoucher", sender: nil)
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
}

extension MVouchersViewController: UIViewControllerPreviewingDelegate{
    
    private func createDetailViewControllerIndexPath(vc: UIViewController, indexPath: IndexPath) -> UIViewController {
        
        let detailViewController = vc
        
        return detailViewController
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        switch voucherType {
        case .vouchers?:
            guard let indexPath = tableView.indexPathForRow(at: location) else {
                return nil
            }
            let voucher = self.dataSource.vouchers[indexPath.row]
            var detailViewController = UIViewController()
            if voucherViewModel.selectedVoucher?.product != nil {
                let productVC = ProductVoucherViewController()
                productVC.address = voucherViewModel.selectedVoucher?.address ?? ""
                detailViewController = productVC
            }else {
                let storyboard = R.storyboard.voucher()
                if let voucherVC = storyboard.instantiateViewController(withIdentifier: "voucher") as? MVoucherViewController {
                    voucherVC.address = voucher.address ?? ""
                    detailViewController = voucherVC
                }
            }
            
            return detailViewController
        default:
            return nil
        }
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}

// MARK: - Add Subviews

extension MVouchersViewController {
    private func addSubviews() {
        let views = [titleLabel, transactionButton, tableView]
        views.forEach { view in
            self.view.addSubview(view)
        }
    }
}

// MARK: - Setup Constraintst

extension MVouchersViewController {
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(40)
            make.left.equalTo(self.view).offset(16)
        }
        
        transactionButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(self.view).offset(-22)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.bottom.equalTo(self.view)
        }
    }
}

extension MVouchersViewController {
    // MARK: - Setup Action
    private func setupAction() {
        transactionButton.actionHandleBlock = { [weak self] (_) in
            self?.transactionButton.removeToolTip(with: Localize.tap_here_you_want_to_see_list_transaction())
            let transactionVC = MTransactionsViewController()
            transactionVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(transactionVC, animated: true)
        }
    }
}

// MARK: - Accessibility Protocol

extension MVouchersViewController: AccessibilityProtocol {
    
    func setupAccessibility() {
//        if let valute = segmentController.accessibilityElement(at: 0) as? UIView {
//            valute.setupAccesibility(description: "Choose to show all valute", accessibilityTraits: .causesPageTurn)
//        }
        
//        if let vouchers = segmentController.accessibilityElement(at: 1) as? UIView {
//            vouchers.setupAccesibility(description: "Choose to show all vouchers", accessibilityTraits: .causesPageTurn)
//        }
        titleLabel.setupAccesibility(description: Localize.vouchers(), accessibilityTraits: .header)
    }
}
