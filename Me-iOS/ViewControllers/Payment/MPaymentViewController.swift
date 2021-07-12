//
//  MPaymentViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class MPaymentViewController: UIViewController {
    
    var isFromReservation: Bool!
    var testToken: String!
    var voucher: Voucher
    var navigator: Navigator
    var selectedAllowerdOrganization: AllowedOrganization!
    
    var dataSource: PaymentDataSource
    
    // MARK: - Parameters
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    @IBOutlet weak var voucherNameLabel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var voucherIcon: CornerImageView!
    @IBOutlet weak var organizationIcon: UIImageView!
    @IBOutlet weak var allowedOriganizationLabel: UILabel!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    @IBOutlet weak var notesView: CustomCornerUIView!
    @IBOutlet weak var chooseOrganizationButton: UIButton!
    @IBOutlet weak var heightFieldsConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var priceUILabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    init(navigator: Navigator, voucher: Voucher) {
        self.voucher = voucher
        self.navigator = navigator
        self.dataSource = PaymentDataSource(voucher: voucher)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        setupTableView()
        setupUI()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    func setupUI(){
        if #available(iOS 11.0, *) {
            self.view.backgroundColor = UIColor(named: "Background_Voucher_DarkTheme")
        } else {}
        
        if #available(iOS 13, *) {
        }else {
            self.setStatusBarStyle(.default)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        tableView.register(MProductVoucherTableViewCell.self, forCellReuseIdentifier: MProductVoucherTableViewCell.identifier)
        tableView.register(OrganizationPaymentTableViewCell.self, forCellReuseIdentifier: OrganizationPaymentTableViewCell.identifier)
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        
    }
    
    
    @IBAction func send(_ sender: Any) {
        _ = "0.01"
        _ = "0,01"
        
        //        if voucher.fund?.currency == "eth" {
        //            limitEN = "0.0001"
        //            limitDT = "0,0001"
        //        }
        
        if voucher.fund != nil {
            
            if voucher.product != nil {
                sendProductTransaction()
            }else if amountField.text != String.empty {
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
        if isFromReservation != nil {
            vc.isFromReservation = isFromReservation
        }
        vc.voucher = voucher
        vc.organizationId = selectedAllowerdOrganization?.id ?? 0
        vc.note = notesField.text
        vc.amount = amountField.text
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    private func sendVoucherTransactions() {
        // Uncomment if eth will be implemented
        //        if amountField.text != limitEN && amountField.text != limitDT{
        
        let vc = ConfirmPaymentPopUp()
        if isFromReservation != nil {
            vc.isFromReservation = isFromReservation
        }
        vc.voucher = voucher
        vc.organizationId = selectedAllowerdOrganization?.id ?? 0
        vc.note = notesField.text
        vc.amount = amountField.text
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
        //        }
        
        //        else {
        //            showSimpleAlert(title: Localize.warning(), message: Localize.payment_of_001_is_to_low_to_be_paid_out_choose_highe_amount())
        //        }
    }
    
    private func sendTestTransaction() {
        let vc = ConfirmPaymentPopUp()
        if isFromReservation != nil {
            vc.isFromReservation = isFromReservation
        }
        vc.organizationId = 0
        vc.testToken = testToken
        vc.note = notesField.text
        vc.amount = amountField.text
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
}


// MARK: - Setup UI
extension MPaymentViewController {
    
    
    
    private func setupProduct() {
        if let price = voucher.product?.price {
            priceUILabel.text = "€ " + price
        }
        arrowIcon.isHidden = true
        chooseOrganizationButton.isHidden = true
        voucherNameLabel.text = voucher.product?.name ?? ""
        voucherIcon.loadImageUsingUrlString(urlString: voucher.product?.photo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
        organizationLabel.text = voucher.product?.organization?.name ?? ""
        allowedOriganizationLabel.text = voucher.product?.organization?.name ?? ""
        organizationIcon.loadImageUsingUrlString(urlString: voucher.product?.photo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
        
        var rectNote = self.notesView.frame
        rectNote.origin.y = 70
        self.notesView.frame = rectNote
        heightFieldsConstraint.constant = 160
    }
    
    private func setupVoucher() {
        if let price = voucher.amount {
            priceUILabel.text = "€ " + price
        }
        voucherNameLabel.text = voucher.fund?.name ?? ""
        voucherIcon.loadImageUsingUrlString(urlString: voucher.fund?.organization?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
        organizationLabel.text = voucher.fund?.organization?.name ?? ""
        allowedOriganizationLabel.text = voucher.allowed_organizations?.first?.name ?? ""
        organizationIcon.loadImageUsingUrlString(urlString: voucher.allowed_organizations?.first?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
        selectedAllowerdOrganization = voucher.allowed_organizations?.first
    }
    
    @IBAction func showOrganizations(_ sender: UIButton) {
        let popOverVC = AllowedOrganizationsViewController(nibName: "AllowedOrganizationsViewController", bundle: nil)
        popOverVC.allowedOrganizations = self.voucher.allowed_organizations!
        popOverVC.delegate = self
        popOverVC.selectedOrganizations = selectedAllowerdOrganization
        self.addChild(popOverVC)
        popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(popOverVC.view)
    }
}

extension MPaymentViewController: AllowedOrganizationsViewControllerDelegate {
    func didSelectEmployeeOrganization(organization: EmployeesOrganization) {
        
    }
    
    func didSelectAllowedOrganization(organization: AllowedOrganization) {
        selectedAllowerdOrganization = organization
        allowedOriganizationLabel.text = organization.name ?? ""
        organizationIcon.loadImageUsingUrlString(urlString: organization.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
    }
}

extension MPaymentViewController {
    private func setupSubview() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

extension MPaymentViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var dotString = ""
        var limitAfterDot = 2
        if self.getLanguageISO() == "en"{
            
            dotString = "."
            
        }else if self.getLanguageISO() == "nl" {
            
            dotString = ","
        }
        
        if let text = textField.text {
            let isDeleteKey = string.isEmpty
            
            if !isDeleteKey {
                if text.contains(dotString) {
                    let countdots = textField.text!.components(separatedBy: dotString).count - 1
                    
                    if countdots > 0 && string == dotString
                    {
                        return false
                    }
                    if voucher.fund?.currency == "eth" {
                        limitAfterDot = 4
                    }
                    if text.components(separatedBy: dotString)[1].count == limitAfterDot {
                        
                        return false
                    }
                }
            }
        }
        return true
    }
    
}
extension MPaymentViewController: AccessibilityProtocol {
    func setupAccessibility() {
        // sendEmailButton.chooseOrganizationButton(description: "Choose Organization Button", accessibilityTraits: .button)
        
    }
}
