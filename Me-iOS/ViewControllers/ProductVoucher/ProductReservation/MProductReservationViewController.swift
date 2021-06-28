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
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = Localize.offer_below_reserved_customer()
        return label
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var goToVoucherButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.backgroundColor = Color.blueText
        button.setTitle(Localize.complete_amount(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.rounded(cornerRadius: 9)
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
        if #available(iOS 11.0, *) {
            self.view.backgroundColor = UIColor(named: "Background_Voucher_DarkTheme")
        } else {}
        setupAccessibility()
        qrViewModel.vcAlert = self
        goToVoucherButton.isHidden = voucher.amount == "0.00"
        // Response
        qrViewModel.getVoucher = { [weak self] (voucher, statusCode) in
            DispatchQueue.main.async {
                self?.voucher = voucher
                self?.navigator.navigate(to: .paymentContinue(voucher))
            }
        }
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(ProductReservationTableViewCell.self, forCellReuseIdentifier: ProductReservationTableViewCell.identifier)
    }
}

extension MProductReservationViewController: UITableViewDelegate {
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.qrViewModel.initVoucherAddress(address: voucherTokens[indexPath.row].address ?? "")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
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
            make.left.equalTo(self.view).offset(16)
            make.right.equalTo(self.view).offset(-16)
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
