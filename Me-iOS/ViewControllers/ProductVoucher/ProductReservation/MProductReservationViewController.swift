//
//  MProductReservationViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 8/22/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MProductReservationViewController: UIViewController {
    
    var voucherTokens: [Transaction]
    var voucher: Voucher
    var navigator: Navigator
    lazy var qrViewModel: QRViewModel = {
        return QRViewModel()
    }()
    var dataSource: ProductReservationDataSource!
    var selectedProduct: Voucher!
    
    // MARK: - Parameters
    
    var descriptionLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansRegular(size: 17)
        label.text = Localize.offer_below_reserved_customer()
        return label
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()
    
    var goToVoucherButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.backgroundColor = Color.blueText
        button.setTitle(Localize.complete_amount(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    
    
    // MARK: - Init
    init(navigator: Navigator, voucherTokens: [Transaction], voucher: Voucher) {
        self.voucherTokens = voucherTokens
        self.voucher = voucher
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
        self.dataSource = ProductReservationDataSource(voucherTokens: voucherTokens)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup View
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        setupView()
    }
    
    private func setupView() {
        setupAccessibility()
        qrViewModel.vcAlert = self
        goToVoucherButton.isHidden = voucher.amount == "0.00"
        // Response
        qrViewModel.getVoucher = { [weak self] (voucher, statusCode) in
            DispatchQueue.main.async {
                self?.selectedProduct = voucher
                self?.performSegue(withIdentifier: "goToPaymentFromSelected", sender: nil)
            }
        }
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.register(ProductReservationTableViewCell.self, forCellReuseIdentifier: ProductReservationTableViewCell.identifier)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPaymentFromSelected" {
            if let paymentVC = segue.destination as? MPaymentViewController {
                
                paymentVC.voucher = selectedProduct
                paymentVC.isFromReservation = true
            }
        }else if segue.identifier == "goToPaymentSimple" {
            if let paymentVC = segue.destination as? MPaymentViewController {
                
                paymentVC.isFromReservation = true
                paymentVC.voucher = voucher
            }
        }
    }
}

extension MProductReservationViewController: UITableViewDelegate {
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.qrViewModel.initVoucherAddress(address: voucherTokens[indexPath.row].address ?? "")
    }
}

extension MProductReservationViewController {
    // MARK: - Add Subviews
    private func addSubviews() {
        let views = [descriptionLabel, tableView, goToVoucherButton]
        views.forEach { view in
            self.view.addSubview(view)
        }
    }
}

extension MProductReservationViewController {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.centerX.equalTo(self.view)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.left.right.equalTo(self.view)
        }
        
        goToVoucherButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.left.equalTo(self.view).offset(15)
            make.height.equalTo(44)
            make.right.equalTo(self.view).offset(-15)
        }
        
    }
}

// MARK: - Accessibility Protocol
extension MProductReservationViewController: AccessibilityProtocol {
    func setupAccessibility() {
        goToVoucherButton.setupAccesibility(description: Localize.complete_amount(), accessibilityTraits: .button)
    }
}
