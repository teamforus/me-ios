//
//  MActionsViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 03.09.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MActionsViewController: UIViewController {
    
    var voucher: Voucher?
    private lazy var viewModel: ActionViewModel = {
        return ActionViewModel()
    }()
    var organization: AllowedOrganization?
    var dataSource: ActionsDataSource!
    
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
        imageView.image = Image.voucherTickerIcon
        return imageView
    }()
    
    private let bodyVoucherView: UIView = {
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
    
    private let imageViewVoucher: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    private let lineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = #colorLiteral(red: 0.8832242489, green: 0.878120482, blue: 0.8911749721, alpha: 1)
        return view
    }()
    
    private let chooseActionLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.text = "Kies een actie"
        label.font = UIFont(name: "GoogleSans-Medium", size: 24)
        return label
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
    imageView.image = Image.faceIcon
      return imageView
  }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = Image.arrowRightIcon
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        tableView.register(ActionTableViewCell.self, forCellReuseIdentifier: ActionTableViewCell.identifier)
    }
    
    private func setVoucher() {
        guard let voucher = self.voucher else {
            return
        }
        
        fundNameLabel.text = voucher.fund?.name
        organizationVoucherLabel.text = voucher.fund?.organization?.name ?? ""
        self.imageViewVoucher.loadImageUsingUrlString(urlString: voucher.fund?.organization?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
    }
    
    private func setupView() {
        setVoucher()
        self.organizationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openOrganization)))
        self.organizationNameLabel.text = voucher?.allowed_organizations?.first?.name ?? ""
        organization = voucher?.allowed_organizations?.first
        
        setupVoucherImageView()
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
    
     func fetchActions() {
        viewModel.fetchSubsidies(voucherAddress: voucher?.address ?? "")
        
        viewModel.complete = { [weak self] (subsidies) in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                if subsidies.count == 0 {
                    self.showSimpleAlertWithSingleAction(title: Localize.warning(), message: Localize.no_balance_for_actions(), okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (_) in
                         self.dismiss(animated: true)
                    }))
                }
                self.dataSource = ActionsDataSource(subsidies: subsidies, viewModel: self.viewModel, parentVC: self)
                self.setupTableView()
                self.tableView.reloadData()
            }
        }
    }
}

extension MActionsViewController: UITableViewDelegate {
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subsidie = dataSource.subsidies[indexPath.row]
        openSubsidiePayment(subsidie: subsidie, organization: organization)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
}

extension MActionsViewController {
    // MARK: - Add Subviews
    private func addSubviews() {
        let views = [bodyView, headerView, chooseActionLabel, organizationView, tableView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        addHeaderSubviews()
        addBodyvoucherViewSubviews()
        addOranizationViewSubviews()
        
    }
    
    private func addHeaderSubviews() {
        let views = [backButton, titleLabel, bodyVoucherView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.headerView.addSubview(view)
        }
    }
    
    private func addBodyvoucherViewSubviews() {
        let views = [voucherImageView, fundNameLabel, organizationVoucherLabel, imageViewVoucher, lineView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.bodyVoucherView.addSubview(view)
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
        
        bodyView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(241)
        }
        
        chooseActionLabel.snp.makeConstraints { make in
            make.top.equalTo(organizationView.snp.bottom).offset(29)
            make.left.equalTo(self.view).offset(20)
        }
        
        organizationView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(60)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(chooseActionLabel.snp.bottom).offset(10)
            make.left.right.bottom.equalTo(self.view)
        }
        
        addHeaderdConstraints()
        addBodyvoucherViewConstraints()
        addOranizationViewConstraints()
    }
    
    private func addHeaderdConstraints() {
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.left.equalTo(headerView).offset(10)
            make.top.equalTo(headerView).offset(35)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalTo(headerView)
        }
        
        bodyVoucherView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalTo(headerView)
            make.height.equalTo(153)
        }
    }
    
    private func addBodyvoucherViewConstraints() {
        voucherImageView.snp.makeConstraints { make in
            make.top.equalTo(bodyVoucherView).offset(11)
            make.left.equalTo(bodyVoucherView).offset(15)
            make.right.equalTo(bodyVoucherView).offset(-15)
            make.height.equalTo(120)
        }
        
        fundNameLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyVoucherView).offset(39)
            make.left.equalTo(bodyVoucherView).offset(32)
            make.right.equalTo(imageViewVoucher.snp.left).offset(-10)
        }
        
        organizationVoucherLabel.snp.makeConstraints { make in
            make.top.equalTo(fundNameLabel.snp.bottom).offset(4)
            make.left.equalTo(bodyVoucherView).offset(32)
            make.right.equalTo(imageViewVoucher.snp.left).offset(-10)
        }
        
        imageViewVoucher.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.right.equalTo(bodyVoucherView).offset(-28)
            make.top.equalTo(bodyVoucherView).offset(36)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.left.right.equalTo(bodyVoucherView)
        }
    }
    
    private func addOranizationViewConstraints() {
        organizationNameLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(organizationView)
            make.left.equalTo(organizationView).offset(64)
            make.right.equalTo(arrowImageView.snp.left).offset(-15)
        }
        
        organizationIamge.snp.makeConstraints { make in
            make.centerY.equalTo(organizationView)
            make.left.equalTo(organizationView).offset(17)
            make.height.width.equalTo(35)
        }
      
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(organizationView)
            make.right.equalTo(organizationView).offset(-17)
            make.height.width.equalTo(30)
        }
    }
}


extension MActionsViewController: OrganizationValidatorViewControllerDelegate {
    func selectOrganizationVoucher(organization: AllowedOrganization, vc: UIViewController) {
        self.organization = organization
        organizationNameLabel.text = organization.name ?? ""
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
    
     func openSubsidiePayment(subsidie: Subsidie, organization: AllowedOrganization?) {
        let paymentVC = MPaymentActionViewController()
        paymentVC.subsidie = subsidie
        paymentVC.fund = voucher?.fund
        paymentVC.organization = organization
        paymentVC.address = voucher?.address ?? ""
        paymentVC.modalPresentationStyle = .fullScreen
        self.present(paymentVC, animated: true)
    }
}
