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

class MPaymentViewController: UIViewController {
    
    var isFromReservation: Bool!
    var testToken: String!
    var voucher: Voucher
    var navigator: Navigator
    var selectedAllowerdOrganization: AllowedOrganization!
    var voucherType: VoucherDetailType
    
    var dataSource: PaymentDataSource
    
    // MARK: - Parameters
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var payButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.backgroundColor = Color.blueText
        button.setTitle(Localize.complete_amount(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.rounded(cornerRadius: 9)
        return button
    }()
    
    
    // MARK: - Init
    init(navigator: Navigator, voucher: Voucher) {
        self.voucher = voucher
        self.navigator = navigator
        self.voucherType = voucher.product != nil ? .product : .budgetVoucher
        self.dataSource = PaymentDataSource(voucher: voucher, voucherType: self.voucherType)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedAllowerdOrganization = voucher.allowed_organizations?.first
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
        
        payButton.actionHandleBlock = { [weak self] (_) in
            self?.makePayment()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        tableView.register(MProductVoucherTableViewCell.self, forCellReuseIdentifier: MProductVoucherTableViewCell.identifier)
        tableView.register(OrganizationPaymentTableViewCell.self, forCellReuseIdentifier: OrganizationPaymentTableViewCell.identifier)
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.identifier)
    }
    
    
    func makePayment() {
        _ = "0.01"
        _ = "0,01"
        if voucher.fund != nil {
            
            if voucher.product != nil {
                sendProductTransaction()
            }else if dataSource.amountValue != String.empty {
                sendVoucherTransactions()
            } else {
                showSimpleAlert(title: Localize.warning(), message: Localize.please_enter_the_amount())
            }
        }else {
            sendTestTransaction()
        }
    }
    
    private func sendProductTransaction() {
        let vc = ConfirmPaymentPopUp()
        vc.voucher = voucher
        vc.organizationId = selectedAllowerdOrganization?.id ?? 0
        vc.note = dataSource.noteValue
        vc.amount = dataSource.amountValue
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    private func sendVoucherTransactions() {
        let vc = ConfirmPaymentPopUp()
        vc.voucher = voucher
        vc.organizationId = selectedAllowerdOrganization?.id ?? 0
        vc.note = dataSource.noteValue
        vc.amount = dataSource.amountValue
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    private func sendTestTransaction() {
        let vc = ConfirmPaymentPopUp()
        vc.organizationId = 0
        vc.testToken = testToken
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
        let popOverVC = AllowedOrganizationsViewController(nibName: "AllowedOrganizationsViewController", bundle: nil)
        popOverVC.allowedOrganizations = self.voucher.allowed_organizations!
        popOverVC.delegate = self
        popOverVC.selectedOrganizations = selectedAllowerdOrganization
        self.addChild(popOverVC)
        self.view.addSubview(popOverVC.view)
        popOverVC.view.snp.makeConstraints { make in
            make.top.bottom.right.left.equalTo(self.view)
        }
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
        let views = [tableView, payButton]
        views.forEach { view in
            self.view.addSubview(view)
        }
    }
}

extension MPaymentViewController {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(400)
        }
        
        payButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.height.equalTo(46)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
        }
    }
}

extension MPaymentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = PaymentRowType.allCases[indexPath.row]
        switch row {
        case .voucher: break
        case .organization:
            self.showOrganizations()
        case .amount: break
        case .note: break
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = PaymentRowType.allCases[indexPath.row]
        switch row {
        case .voucher:
            return 120
        case .organization:
            return 60
        case .amount:
            return voucherType == .budgetVoucher ?  70 : 0
        case .note:
            return 100
        }
    }
}

extension MPaymentViewController: AccessibilityProtocol {
    func setupAccessibility() {
        // sendEmailButton.chooseOrganizationButton(description: "Choose Organization Button", accessibilityTraits: .button)
    }
}
