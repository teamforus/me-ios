//
//  ProductVoucherViewController.swift
//  Me-iOS
//
//  Created by mac on 03.02.2021.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

enum MainTableViewSection: Int, CaseIterable {
    case voucher = 0
    case infoVoucher = 1
    case mapDetail = 2
    case adress = 3
    case telephone = 4
    case branches = 5
}

class ProductVoucherViewController: UIViewController {
    
    // MARK: - Properties
  
  var voucher: Voucher!
  var address: String!
  lazy var productViewModel: ProductVoucherViewModel = {
      return ProductVoucherViewModel()
  }()
  
    private let backButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Product Voucher"
        label.font = R.font.googleSansMedium(size: 17)
        label.textColor = .black
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9646012187, green: 0.9647662044, blue: 0.9645908475, alpha: 1)
        addSubviews()
        setUpTableView()
        addCosntrains()
        setUpActions()
        getApiRequest()
    }
  
  func getApiRequest(){
    productViewModel.complete = { [weak self] (voucher) in
          DispatchQueue.main.async {
            self?.voucher = voucher
            self?.tableView.reloadData()
              if voucher.expire_at?.date?.formatDate() ?? Date() > Date() {
//                  self?.qrCodeImage.isHidden = false
//                  self?.sendEmailButton.isHidden = false
//                  self?.voucherInfoButton.isHidden = false
//                  self?.buttonsView.isHidden = false
//                  self?.heightConstraintsHeaderView.constant = 322
//                  self?.qrCodeButton.isEnabled = true
              }
//              self?.productNameLabel.text = voucher.product?.name ?? ""
//              self?.organizationNameLabel.text = voucher.fund?.organization?.name ?? ""
//              self?.organizationProductName.text = voucher.product?.organization?.name ?? ""
//              self?.addressLabel.text = voucher.offices?.first?.address ?? ""
//              self?.phoneNumberLabel.text = voucher.offices?.first?.phone ?? ""
//              self?.emailButton.setTitle(voucher.offices?.first?.organization?.email, for: .normal)
//              self?.organizationIcon.loadImageUsingUrlString(urlString: voucher.product?.organization?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
//              self?.qrCodeImage.generateQRCode(from: "{\"type\": \"voucher\",\"value\": \"\(voucher.address ?? "")\" }")
//              self?.voucher = voucher
//              //organizationLabel gesture
//              self?.emailButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self?.Tap)))
//              self?.emailButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self?.Long)))
//
//
//              if let latitudeValue = voucher.offices?.first?.lat, let lat = Double(latitudeValue) {
//                  self?.latitude = lat
//              }
//
//              if let longitudeValue = voucher.offices?.first?.lon, let lon = Double(longitudeValue) {
//                  self?.longitude = lon
//              }
//              self?.mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self?.goToMap)))
//              let viewRegion = MKCoordinateRegion( center: CLLocationCoordinate2D(latitude: self?.latitude ?? 0.0 , longitude: self?.longitude ?? 0.0), latitudinalMeters: 10000, longitudinalMeters: 10000)
//              self?.mapView.setRegion(viewRegion, animated: false)
//              self?.mapView.region = viewRegion
//
//              voucher.offices?.forEach({ (office) in
//
//                  self?.mapView.addAnnotation((self?.setAnnotation(lattitude: self?.latitude ?? 0.0, longitude: self?.longitude ?? 0.0))!)
//              })
//              self?.labeles.forEach { (view) in
//                  view.stopAnimating()
//              }
//              self?.images.forEach { (view) in
//                  view.stopAnimating()
//              }
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
        tableView.dataSource = self
        tableView.register(MProductVoucherTableViewCell.self, forCellReuseIdentifier: MProductVoucherTableViewCell.identifier)
        tableView.register(MTelephoneTableViewCell.self, forCellReuseIdentifier: MTelephoneTableViewCell.identifier)
        tableView.register(MBranchesTableViewCell.self, forCellReuseIdentifier: MBranchesTableViewCell.identifier)
        tableView.register(MAdressTableViewCell.self, forCellReuseIdentifier: MAdressTableViewCell.identifier)
        tableView.register(MMapDetailsTableViewCell.self, forCellReuseIdentifier: MMapDetailsTableViewCell.identifier)
        tableView.register(MMapDetailsTableViewCell.self, forCellReuseIdentifier: MMapDetailsTableViewCell.identifier)
        tableView.register(MInfoVoucherTableViewCell.self, forCellReuseIdentifier: MInfoVoucherTableViewCell.identifier)
    }
}

extension ProductVoucherViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainTableViewSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sections = MainTableViewSection.allCases[indexPath.row]
        switch sections {
        case .voucher:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MProductVoucherTableViewCell.identifier, for: indexPath) as? MProductVoucherTableViewCell else {
              return UITableViewCell()
            }
          cell.setupVoucher(voucher: voucher)
            return cell
        case .infoVoucher:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MInfoVoucherTableViewCell.identifier, for: indexPath) as? MInfoVoucherTableViewCell else {
                return UITableViewCell()
            }
            return cell
        case .mapDetail:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MMapDetailsTableViewCell.identifier, for: indexPath) as? MMapDetailsTableViewCell else {
                return UITableViewCell()
            }
            return cell
            
        case .adress:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MAdressTableViewCell.identifier, for: indexPath) as? MAdressTableViewCell else {
                return UITableViewCell()
            }
            return cell
            
        case .telephone:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MTelephoneTableViewCell.identifier, for: indexPath) as? MTelephoneTableViewCell else {
                return UITableViewCell()
            }
            return cell
            
        case .branches:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MBranchesTableViewCell.identifier, for: indexPath) as? MBranchesTableViewCell else {
                return UITableViewCell()
            }
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sections = MainTableViewSection.allCases[indexPath.row]
        
        switch sections {
        case .voucher:
            return 120
        case .infoVoucher:
            return 85
        case .mapDetail:
            return 275
        case .adress:
            return 78
        case .telephone:
            return 82
        case .branches:
            return 80
        }
    }
    
    
}

extension ProductVoucherViewController {
    
    // MARK: - Add Subviews
    private func addSubviews(){
        let views = [tableView, backButton, titleLabel]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
    }
}

extension ProductVoucherViewController{
    
    // MARK: - Add Constraints
    private func addCosntrains(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 103),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 54),
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 14),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.widthAnchor.constraint(equalToConstant: 44),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 56),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.backButton.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
        ])
        
    }
}


extension ProductVoucherViewController{
    
    //MARK: - Setup Actions
    private func setUpActions(){
        backButton.actionHandleBlock = { [weak self] (button) in
            self?.back(button)
        }
    }
}
