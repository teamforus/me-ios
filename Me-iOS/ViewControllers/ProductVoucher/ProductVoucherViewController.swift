//
//  ProductVoucherViewController.swift
//  Me-iOS
//
//  Created by mac on 03.02.2021.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

enum MainTableViewSection: Int, CaseIterable {
    case voucher = 0
    case infoVoucher
    case mapDetail
    case adress
    case telephone
    case email
    case branches
}

class ProductVoucherViewController: UIViewController {
    
    var voucher: Voucher!
    var address: String!
    var dataSource: ProductVoucherDataSource!
    lazy var productViewModel: ProductVoucherViewModel = {
        return ProductVoucherViewModel()
    }()
    
    // MARK: - Properties
    
    private let tableView: TableView_Background_DarkMode = {
        let tableView = TableView_Background_DarkMode(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.colorName = "Background_Voucher_DarkTheme"
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9646012187, green: 0.9647662044, blue: 0.9645908475, alpha: 1)
        addSubviews()
        addCosntrains()
        setupUI()
    }
    
    private func setupUI() {
        setUpActions()
        getApiRequest()
        if #available(iOS 11.0, *) {
            self.view.backgroundColor = UIColor(named: "Background_Voucher_DarkTheme")
        } else {}
    }
    
    func getApiRequest(){
        productViewModel.complete = { [weak self] (voucher) in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.voucher = voucher
                self.dataSource = ProductVoucherDataSource(voucher: voucher, parentViewController: self)
                self.setUpTableView()
                self.tableView.reloadData()
            }
        }
        
        if isReachable() {
            productViewModel.vc = self
            productViewModel.initFetchById(address: address)
        }else {
            showInternetUnable()
        }
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(MProductVoucherTableViewCell.self, forCellReuseIdentifier: MProductVoucherTableViewCell.identifier)
        tableView.register(MTelephoneTableViewCell.self, forCellReuseIdentifier: MTelephoneTableViewCell.identifier)
        tableView.register(MBranchesTableViewCell.self, forCellReuseIdentifier: MBranchesTableViewCell.identifier)
        tableView.register(MAdressTableViewCell.self, forCellReuseIdentifier: MAdressTableViewCell.identifier)
        tableView.register(MMapDetailsTableViewCell.self, forCellReuseIdentifier: MMapDetailsTableViewCell.identifier)
        tableView.register(MMapDetailsTableViewCell.self, forCellReuseIdentifier: MMapDetailsTableViewCell.identifier)
        tableView.register(MInfoVoucherTableViewCell.self, forCellReuseIdentifier: MInfoVoucherTableViewCell.identifier)
    }
}

extension ProductVoucherViewController: UITableViewDelegate {
    // MARK: - UITableViewDelegate
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sections = MainTableViewSection.allCases[indexPath.row]
        switch sections {
        case .voucher:
            self.dataSource.didOpenQR()
        case .telephone:
            dataSource.callPhone()
        case .email, .infoVoucher,  .mapDetail, .adress, .branches: break
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sections = MainTableViewSection.allCases[indexPath.row]
        
        switch sections {
        case .voucher:
            return 120
        case .infoVoucher:
            return 70
        case .mapDetail:
            return 275
        case .adress:
            return 78
        case .telephone:
            return 82
        case .email:
            return 82
        case .branches:
            return 168
        }
    }
    
}

extension ProductVoucherViewController {
    
    // MARK: - Add Subviews
    private func addSubviews(){
        let views = [tableView]
        views.forEach { (view) in
            self.view.addSubview(view)
        }
    }
}

extension ProductVoucherViewController{
    
    // MARK: - Add Constraints
    private func addCosntrains(){
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}


extension ProductVoucherViewController{
    
    //MARK: - Setup Actions
    private func setUpActions(){
    }
    
    func sendEmailToProvider() {
        showSimpleAlertWithAction(title: Localize.send_an_email_to_the_provider(),
                                  message: Localize.confirm_to_go_your_email_app_to_send_message_to_provider(),
                                  okAction: UIAlertAction(title: Localize.confirm(), style: .default, handler: { (action) in
                                    
                                    if MFMailComposeViewController.canSendMail() {
                                        let composeVC = MFMailComposeViewController()
                                        composeVC.mailComposeDelegate = self
                                        composeVC.setToRecipients([(self.voucher.offices?.first?.organization?.email)!])
                                        composeVC.setSubject(Localize.question_from_me_user())
                                        composeVC.setMessageBody("", isHTML: false)
                                        self.present(composeVC, animated: true, completion: nil)
                                    }else{
                                        self.showSimpleAlert(title: Localize.warning(), message: Localize.mail_services_are_not_available())
                                    }
                                    
                                  }),
                                  cancelAction: UIAlertAction(title: Localize.cancel(), style: .cancel, handler: nil))
    }
}

// MARK: - Mail Delegate
extension ProductVoucherViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
