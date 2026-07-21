//
//  MPaymentViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

enum VoucherDetailType {
    case product, budgetVoucher
}

enum PaymentContext {
    case voucher(Voucher)
    case demo(token: String)

    var isDemo: Bool {
        if case .demo = self {
            return true
        }

        return false
    }
}

class MPaymentViewController: UIViewController {
    
    var isFromReservation: Bool!
    var navigator: Navigator
    var selectedAllowerdOrganization: AllowedOrganization!
    var voucherType: VoucherDetailType
    internal let sheetTransitioningDelegate = SheetTransitioningDelegate()
    var dataSource: PaymentDataSource
    let paymentContext: PaymentContext
    
    // MARK: - Parameters
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    // MARK: - Init
    init(navigator: Navigator, voucher: Voucher) {
        self.paymentContext = .voucher(voucher)
        self.navigator = navigator
        self.voucherType = voucher.product != nil ? .product : .budgetVoucher
        self.dataSource = PaymentDataSource(paymentContext: .voucher(voucher), voucherType: self.voucherType)
        super.init(nibName: nil, bundle: nil)
    }

    init(navigator: Navigator, demoToken: String) {
        self.paymentContext = .demo(token: demoToken)
        self.navigator = navigator
        self.voucherType = .budgetVoucher
        self.dataSource = PaymentDataSource(paymentContext: .demo(token: demoToken), voucherType: .budgetVoucher)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

        if case .voucher(let voucher) = paymentContext {
            selectedAllowerdOrganization = voucher.allowed_organizations?.first
        }

        addSubviews()
        setupConstraints()
        setupUI()
    }
    
    func setupUI(){
        if #available(iOS 11.0, *) {
            self.view.backgroundColor = UIColor(named: "Background_Voucher_DarkTheme")
        } else {}
        
        if #available(iOS 13, *) {
        }else {
            self.setStatusBarStyle(.default)
        }
        setupTableView()
        
//        payButton.actionHandleBlock = { [weak self] (_) in
//            self?.makePayment()
//        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        tableView.register(MProductVoucherTableViewCell.self, 
                           forCellReuseIdentifier: MProductVoucherTableViewCell.identifier)
        tableView.register(OrganizationPaymentTableViewCell.self,
                           forCellReuseIdentifier: OrganizationPaymentTableViewCell.identifier)
        tableView.register(TextFieldTableViewCell.self,
                           forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        tableView.register(PaymentTableViewCell.self,
                           forCellReuseIdentifier: PaymentTableViewCell.identifier)
        
        dataSource.paymentHandleBlock = { [weak self] (_) in
            self?.makePayment()
        }
    }
    
    
    func makePayment() {
        switch paymentContext {
        case .voucher(let voucher):
            if voucher.product != nil {
                sendProductTransaction(voucher: voucher)
            } else if dataSource.amountValue != String.empty {
                sendVoucherTransactions(voucher: voucher)
            } else {
                showSimpleAlert(
                    title: Localize.warning(),
                    message: Localize.please_enter_the_amount(),
                )
            }

        case .demo(let token):
            if dataSource.amountValue != String.empty {
                sendTestTransaction(token: token)
            } else {
                showSimpleAlert(
                    title: Localize.warning(),
                    message: Localize.please_enter_the_amount(),
                )
            }
        }
    }
    
    private func sendProductTransaction(voucher: Voucher) {

        let vc = ConfirmPaymentPopUp()
        vc.voucher = voucher
        vc.organizationId = selectedAllowerdOrganization?.id ?? 0
        vc.note = dataSource.noteValue
        vc.amount = dataSource.amountValue
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
        
    }
    
    private func sendVoucherTransactions(voucher: Voucher) {
        self.view.endEditing(true)
        let amountVoucher = Double(voucher.amount ?? "0.00")!
        _ = Double(dataSource.amountValue.replacingOccurrences(of: ",", with: "."))! - amountVoucher
        
        if Double(dataSource.amountValue.replacingOccurrences(of: ",", with: "."))! > amountVoucher {
            let confirmAuthVC = MConfirmPaymentViewController()
            confirmAuthVC.voucher = voucher
            confirmAuthVC.organizationId = selectedAllowerdOrganization?.id ?? 0
            confirmAuthVC.note = dataSource.noteValue
            confirmAuthVC.amount = dataSource.amountValue
            confirmAuthVC.modalPresentationStyle = .custom
            confirmAuthVC.transitioningDelegate = self.sheetTransitioningDelegate
            self.present(confirmAuthVC, animated: true, completion: nil)
            
        } else {
            let vc = ConfirmPaymentPopUp()
            vc.voucher = voucher
            vc.organizationId = selectedAllowerdOrganization?.id ?? 0
            vc.note = dataSource.noteValue
            vc.amount = dataSource.amountValue
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true)
        }
    }
    
    private func sendTestTransaction(token: String) {
        self.view.endEditing(true)

        let vc = ConfirmPaymentPopUp()
        vc.organizationId = 0
        vc.demoToken = token
        vc.note = dataSource.noteValue
        vc.amount = dataSource.amountValue
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
}


// MARK: - Setup UI
extension MPaymentViewController {
    
    func showOrganizations() {
        guard case .voucher(let voucher) = paymentContext,
              let allowedOrganizations = voucher.allowed_organizations else {
            return
        }

        let popOverVC = AllowedOrganizationsViewController(nibName: "AllowedOrganizationsViewController", 
                                                           bundle: nil)
        popOverVC.allowedOrganizations = allowedOrganizations
        popOverVC.delegate = self
        popOverVC.selectedOrganizations = selectedAllowerdOrganization
        self.addChild(popOverVC)
        popOverVC.view.frame = CGRect(x: 0, 
                                      y: 0,
                                      width: self.view.frame.size.width,
                                      height: self.view.frame.size.height)
        self.view.addSubview(popOverVC.view)
    }
}

extension MPaymentViewController: AllowedOrganizationsViewControllerDelegate {
    func didSelectEmployeeOrganization(organization: EmployeesOrganization) {
        
    }
    
    func didSelectAllowedOrganization(organization: AllowedOrganization) {
        selectedAllowerdOrganization = organization
        self.dataSource.selectedOrganization = organization
        self.tableView.reloadData()
    }
}

extension MPaymentViewController {
    private func addSubviews() {
        let views = [tableView]
        views.forEach { view in
            self.view.addSubview(view)
        }
    }
}

extension MPaymentViewController {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

extension MPaymentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = PaymentRowType.allCases[indexPath.row]
        switch row {
        case .voucher: break
        case .organization:
            if !paymentContext.isDemo {
                self.showOrganizations()
            }
        case .amount: break
        case .note: break
        case .payment:
            self.makePayment()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = PaymentRowType.allCases[indexPath.row]
        switch row {
        case .voucher:
            return 120
        case .organization:
            return 70
        case .amount:
            return paymentContext.isDemo || voucherType == .budgetVoucher ? 70 : 0
        case .note:
            return 110
        case .payment:
            return 60
        }
    }
}

extension MPaymentViewController: AccessibilityProtocol {
    func setupAccessibility() {
        // sendEmailButton.chooseOrganizationButton(description: "Choose Organization Button", accessibilityTraits: .button)
    }
}
