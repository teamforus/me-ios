//
//  MActionsViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 03.09.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit
import RESegmentedControl

enum SubsidyType {
    case reservation, offers
}

class MActionsViewController: UIViewController {
    
    var voucher: Voucher?
    private lazy var viewModel: ActionViewModel = {
        return ActionViewModel()
    }()
    
    private lazy var viewModelVouchers: ProdcutVouchersViewModel = {
        return ProdcutVouchersViewModel()
    }()
    
    var subsidyType: SubsidyType = .reservation
    
    var organization: AllowedOrganization?
    
    
    // MARK: - Properties
    let bodyView: Background_DarkMode = {
        let view = Background_DarkMode(frame: .zero)
        view.colorName = "Background_Voucher_DarkTheme"
        return view
    }()
    
    private let headerView: Background_DarkMode = {
        let view = Background_DarkMode(frame: .zero)
        view.colorName = "WhiteBackground_DarkTheme"
        return view
    }()
    
    private let backButton: BackButton_DarkMode = {
        let button = BackButton_DarkMode(frame: .zero)
        button.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.text = Localize.payment()
        label.textAlignment = .center
        label.font = UIFont(name: "GoogleSans-Medium", size: 17)
        return label
    }()
    
    private let voucherImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleToFill
        imageView.image = R.image.xVoucherSurface()
        return imageView
    }()
    
    private let bodyvoucherView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()
    
    private let fundNameLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Medium", size: 21)
        return label
    }()
    
    private let organizationVoucherLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Regular", size: 14)
        return label
    }()
    
    private let priceVoucherLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Regular", size: 14)
        return label
    }()
    
    private let imageViewVoucher: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    private let lineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = #colorLiteral(red: 0.8832242489, green: 0.878120482, blue: 0.8911749721, alpha: 1)
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let organizationView: Background_DarkMode = {
        let view = Background_DarkMode(frame: .zero)
        view.colorName = "WhiteBackground_DarkTheme"
        return view
    }()
    
    private let organizationNameLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Medium", size: 18)
        return label
    }()
  
  private let organizationIamge: UIImageView = {
      let imageView = UIImageView(frame: .zero)
      imageView.contentMode = .scaleToFill
      imageView.image = R.image.face24Px()
      return imageView
  }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = R.image.roundedRight()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let segmentView: Background_DarkMode = {
        let view = Background_DarkMode(frame: .zero)
        view.colorName = "WhiteBackground_DarkTheme"
        return view
    }()
    
    let segmentedControl: RESegmentedControl = {
        let control = RESegmentedControl(frame: .zero)
        return control
    }()
    
    private let titleTableViewHeader: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Regular", size: 14)
        label.text = "Onderstaand aanbod is door de klant gereserveerd"
        label.numberOfLines = 2
        return label
    }()
    
    private let payButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.backgroundColor = #colorLiteral(red: 0.1918309331, green: 0.3696506619, blue: 0.9919955134, alpha: 1)
        button.setTitle(Localize.complete_amount(), for: .normal)
        button.titleLabel?.font = R.font.googleSansBold(size: 14)
        button.rounded(cornerRadius: 6)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addSubviews()
        addConstraints()
        setupView()
        fetchActions()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ActionTableViewCell.self, forCellReuseIdentifier: ActionTableViewCell.identifier)
    }
    
    private func setVoucher() {
        guard let voucher = self.voucher else {
            return
        }
        
        fundNameLabel.text = voucher.fund?.name
        if let price = voucher.amount {
            self.priceVoucherLabel.text = "€ \(price.substringLeftPart()),\(price.substringRightPart())"
        }
        priceVoucherLabel.isHidden = voucher.fund?.type == FundType.subsidies.rawValue || voucher.product != nil
        
        
        organizationVoucherLabel.text = voucher.fund?.organization?.name ?? ""
        self.imageViewVoucher.loadImageUsingUrlString(urlString: voucher.fund?.organization?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
    }
    
    private func setupView() {

        setVoucher()
        self.organizationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openOrganization)))
        self.organizationNameLabel.text = voucher?.allowed_organizations?.first?.name ?? ""
        organization = voucher?.allowed_organizations?.first
        setupSegmentControll()
        setupVoucherImageView()
        
        payButton.actionHandleBlock = { [weak self] (_) in
            guard let self = self else { return }
            
            let paymentStoryboard = R.storyboard.payment()
            if let payment = paymentStoryboard.instantiateViewController(withIdentifier: "content") as? MPaymentViewController {
//                paymen.testToken = self.testToken
                payment.voucher = self.voucher
//                paymentVC.destination.tabBar = self.tabBarController
                payment.modalPresentationStyle = .fullScreen
                self.present(payment, animated: true)
            }
        }
        
    }
    
    private func setupSegmentControll() {
        let segmentItems = [SegmentModel(title: "Reserveringen", imageName: "reservation_icon"), SegmentModel(title: "Aanbod", imageName: "offer_icon")]
        
        var color = UIColor.white
        
        if #available(iOS 11.0, *) {
            color = UIColor(named: "WhiteBackground_DarkTheme") ?? .white
        } else {
            
        }
        
        var preset = MaterialPreset(backgroundColor: color, tintColor: #colorLiteral(red: 0.1918309331, green: 0.3696506619, blue: 0.9919955134, alpha: 1))
        preset.segmentItemStyle.textColor = #colorLiteral(red: 0.3331416845, green: 0.3331416845, blue: 0.3331416845, alpha: 1)
        preset.segmentSelectedItemStyle.size = .height(2, position: .bottom)
        preset.imageRenderMode = .alwaysTemplate
        preset.tintColor = #colorLiteral(red: 0.3331416845, green: 0.3331416845, blue: 0.3331416845, alpha: 1)
        segmentedControl.configure(segmentItems: segmentItems, preset: preset)
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(sender:)), for: .valueChanged)
    }
    
    @objc func segmentedControlValueChanged(sender: RESegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            subsidyType = .reservation
            fetchActions()
        case 1:
            subsidyType = .offers
            fetchActions()
        default:
            break
        }
    }
    
    private func setupVoucherImageView() {
        let frame = self.view.frame
        let width = frame.width - 30
        voucherImageView.layer.shadowColor = UIColor.black.cgColor
        voucherImageView.layer.shadowOffset = CGSize(width: 0, height: 8)
        voucherImageView.layer.shadowOpacity = 0.3
        voucherImageView.layer.shadowRadius = 10
        voucherImageView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: 120)).cgPath
        voucherImageView.layer.shouldRasterize = false
    }
    
    private func fetchActions() {
        KVSpinnerView.show()
        viewModel.fetchSubsidies(voucherAddress: voucher?.address ?? "", organizationId: String(self.organization?.id ?? 0))
        
        viewModel.complete = { [weak self] (subsidies) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                KVSpinnerView.dismiss()
            }
        }
        
        viewModelVouchers.fetchSubsidies(voucherAddress: voucher?.address ?? "", organizationId: String(self.organization?.id ?? 0))
        
        viewModelVouchers.complete = { [weak self] (subsidies) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                KVSpinnerView.dismiss()
            }
        }
        
        
    }
}

extension MActionsViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch subsidyType {
        case .reservation:
            return viewModelVouchers.numberOfCells
            
        case .offers:
            return viewModel.numberOfCells
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionTableViewCell.identifier, for: indexPath) as? ActionTableViewCell else {
            return UITableViewCell()
        }
        switch subsidyType {
        case .reservation:
            let voucher = viewModelVouchers.getCellViewModel(at: indexPath)
            cell.setupActions(voucher: voucher)
            
//            if viewModelVouchers.numberOfCells - 1 == indexPath.row {
//                if viewModelVouchers.lastPage != viewModelVouchers.currentPage {
//                    self.fetchActions()
//                }
//            }
            
        case .offers:
            let subsidie = viewModel.getCellViewModel(at: indexPath)
            cell.setupActions(subsidie: subsidie)
            
//            if viewModel.numberOfCells - 1 == indexPath.row {
//                if viewModel.lastPage != viewModel.currentPage {
//                    self.fetchActions()
//                }
//            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch subsidyType {
        case .reservation:
            let voucher = viewModelVouchers.getCellViewModel(at: indexPath)
            let paymentStoryboard = R.storyboard.payment()
            if let payment = paymentStoryboard.instantiateViewController(withIdentifier: "content") as? MPaymentViewController {
//                paymen.testToken = self.testToken
                payment.voucher = voucher
//                paymentVC.destination.tabBar = self.tabBarController
                payment.modalPresentationStyle = .fullScreen
                self.present(payment, animated: true)
            }
            
        case .offers:
            let subsidie = viewModel.getCellViewModel(at: indexPath)
            openSubsidiePayment(subsidie: subsidie, organization: organization)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
}

extension MActionsViewController {
    // MARK: - Add Subviews
    private func addSubviews() {
        let views = [bodyView, headerView, organizationView, tableView, segmentView, segmentedControl, titleTableViewHeader, payButton]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        addHeaderSubviews()
        addBodyvoucherViewSubviews()
        addOranizationViewSubviews()
        
    }
    
    private func addHeaderSubviews() {
        let views = [backButton, titleLabel, bodyvoucherView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.headerView.addSubview(view)
        }
    }
    
    private func addBodyvoucherViewSubviews() {
        let views = [voucherImageView, fundNameLabel, organizationVoucherLabel, priceVoucherLabel, imageViewVoucher, lineView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.bodyvoucherView.addSubview(view)
        }
    }
    
    private func addOranizationViewSubviews() {
        let views = [organizationNameLabel, organizationIamge ,arrowImageView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.organizationView.addSubview(view)
        }
    }
}

extension MActionsViewController {
    // MARK: - Add Constraints
    private func addConstraints() {
        NSLayoutConstraint.activate([
            bodyView.topAnchor.constraint(equalTo: self.view.topAnchor),
            bodyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bodyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 241)
        ])
        
        NSLayoutConstraint.activate([
            organizationView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
            organizationView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            organizationView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            organizationView.heightAnchor.constraint(equalToConstant: 62)
        ])
        
        NSLayoutConstraint.activate([
            segmentView.topAnchor.constraint(equalTo: organizationView.bottomAnchor, constant: 1),
            segmentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            segmentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            segmentView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: organizationView.bottomAnchor, constant: 1),
            segmentedControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        
        NSLayoutConstraint.activate([
            titleTableViewHeader.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            titleTableViewHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 21),
            titleTableViewHeader.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -21),
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleTableViewHeader.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                payButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 12),
                payButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                payButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
                payButton.heightAnchor.constraint(equalToConstant: voucher?.fund?.type == FundType.subsidies.rawValue || voucher?.product != nil ? 0 : 46),
                payButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            ])
        } else {
            NSLayoutConstraint.activate([
                payButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 12),
                payButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                payButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
                payButton.heightAnchor.constraint(equalToConstant: voucher?.fund?.type == FundType.subsidies.rawValue || voucher?.product != nil ? 0 : 46),
                payButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20)
            ])
        }
        
        
        
        addHeaderdConstraints()
        addBodyvoucherViewConstraints()
        addOranizationViewConstraints()
    }
    
    private func addHeaderdConstraints() {
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 35)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bodyvoucherView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            bodyvoucherView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            bodyvoucherView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            bodyvoucherView.heightAnchor.constraint(equalToConstant: 153)
        ])
        
    }
    
    private func addBodyvoucherViewConstraints() {
        NSLayoutConstraint.activate([
            voucherImageView.leadingAnchor.constraint(equalTo: bodyvoucherView.leadingAnchor, constant: 15),
            voucherImageView.trailingAnchor.constraint(equalTo: bodyvoucherView.trailingAnchor, constant: -15),
            voucherImageView.topAnchor.constraint(equalTo: bodyvoucherView.topAnchor, constant: 11),
            voucherImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            fundNameLabel.topAnchor.constraint(equalTo: bodyvoucherView.topAnchor, constant: 39),
            fundNameLabel.leadingAnchor.constraint(equalTo: bodyvoucherView.leadingAnchor, constant: 32),
            fundNameLabel.trailingAnchor.constraint(equalTo: imageViewVoucher.leadingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            organizationVoucherLabel.topAnchor.constraint(equalTo: fundNameLabel.bottomAnchor, constant: 4),
            organizationVoucherLabel.leadingAnchor.constraint(equalTo: bodyvoucherView.leadingAnchor, constant: 32),
            organizationVoucherLabel.trailingAnchor.constraint(equalTo: imageViewVoucher.leadingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            priceVoucherLabel.topAnchor.constraint(equalTo: organizationVoucherLabel.bottomAnchor, constant: 4),
            priceVoucherLabel.leadingAnchor.constraint(equalTo: bodyvoucherView.leadingAnchor, constant: 32),
            priceVoucherLabel.trailingAnchor.constraint(equalTo: imageViewVoucher.leadingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            imageViewVoucher.heightAnchor.constraint(equalToConstant: 70),
            imageViewVoucher.widthAnchor.constraint(equalToConstant: 70),
            imageViewVoucher.trailingAnchor.constraint(equalTo: bodyvoucherView.trailingAnchor, constant: -28),
            imageViewVoucher.topAnchor.constraint(equalTo: bodyvoucherView.topAnchor, constant: 36)
        ])
        
        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.bottomAnchor.constraint(equalTo: bodyvoucherView.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: bodyvoucherView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: bodyvoucherView.trailingAnchor)
        ])
    }
    
    private func addOranizationViewConstraints() {
      NSLayoutConstraint.activate([
        organizationNameLabel.topAnchor.constraint(equalTo: organizationView.topAnchor),
        organizationNameLabel.leadingAnchor.constraint(equalTo: organizationView.leadingAnchor, constant: 64),
        organizationNameLabel.bottomAnchor.constraint(equalTo: organizationView.bottomAnchor),
        organizationNameLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: 15)
      ])
      
      NSLayoutConstraint.activate([
        organizationIamge.centerYAnchor.constraint(equalTo: organizationView.centerYAnchor),
        organizationIamge.leadingAnchor.constraint(equalTo: organizationView.leadingAnchor, constant: 17),
        organizationIamge.heightAnchor.constraint(equalToConstant: 35),
        organizationIamge.widthAnchor.constraint(equalToConstant: 35)
      ])
      
      NSLayoutConstraint.activate([
        arrowImageView.centerYAnchor.constraint(equalTo: organizationView.centerYAnchor),
        arrowImageView.trailingAnchor.constraint(equalTo: organizationView.trailingAnchor, constant: -17),
        arrowImageView.heightAnchor.constraint(equalToConstant: 30),
        arrowImageView.widthAnchor.constraint(equalToConstant: 30)
      ])
    }
}


extension MActionsViewController: OrganizationValidatorViewControllerDelegate {
    func selectOrganizationVoucher(organization: AllowedOrganization, vc: UIViewController) {
        self.organization = organization
        organizationNameLabel.text = organization.name ?? ""
        fetchActions()
    }
    
    func close() {
        
    }
    
    func selectOrganization(organization: EmployeesOrganization, vc: UIViewController) {
        
    }
}

extension MActionsViewController {
    // MARK: - Actions
    @objc private func openOrganization() {
        let popOverVC = OrganizationValidatorViewController(nibName: "OrganizationValidatorViewController", bundle: nil)
        popOverVC.organizationType = .subsidieOrganization
        popOverVC.allowedOrganization = voucher?.allowed_organizations ?? []
        popOverVC.delegate = self
        self.addChild(popOverVC)
        popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(popOverVC.view)
    }
    
    private func openSubsidiePayment(subsidie: Subsidie, organization: AllowedOrganization?) {
        let paymentVC = MPaymentActionViewController()
        paymentVC.subsidie = subsidie
        paymentVC.fund = voucher?.fund
        paymentVC.organization = organization
        paymentVC.address = voucher?.address ?? ""
        paymentVC.modalPresentationStyle = .fullScreen
        self.present(paymentVC, animated: true)
    }
}
