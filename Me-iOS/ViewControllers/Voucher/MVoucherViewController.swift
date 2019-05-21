//
//  MVoucherViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SafariServices

class MVoucherViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateCreated: UILabel!
    @IBOutlet weak var voucherName: UILabel!
    @IBOutlet weak var organizationName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qrImage: UIImageView!
    
    lazy var voucherViewModel: VoucherViewModel = {
        return VoucherViewModel()
    }()
    var address: String!
    var voucher: Voucher!
    @IBOutlet var labeles: [SkeletonView]!
    @IBOutlet var images: [SkeletonUIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labeles.forEach { (view) in
            view.startAnimating()
        }
        
        images.forEach { (view) in
            view.startAnimating()
        }
        voucherViewModel.reloadDataVoucher = { [weak self] (voucher) in
            
            DispatchQueue.main.async {
                
                self?.voucherName.text = voucher.fund?.name ?? ""
                self?.organizationName.text = voucher.fund?.organization?.name ?? ""
                if let price = voucher.amount {
                    
                    self?.priceLabel.attributedText = "€ \(price.substringLeftPart()).{\(price.substringRightPart())}".customText(fontBigSize: 20, minFontSize: 14)
                }else {
                    
                    self?.priceLabel.attributedText = "0.{0}".customText(fontBigSize: 20, minFontSize: 14)
                }
                
                self?.qrImage.generateQRCode(from: "{\"type\": \"voucher\",\"value\": \"\(voucher.address ?? "")\" }")
                self?.dateCreated.text = voucher.created_at?.dateFormaterNormalDate()
                self?.voucher = voucher
                
                self?.labeles.forEach { (view) in
                    view.stopAnimating()
                }
                self?.images.forEach { (view) in
                    view.stopAnimating()
                }
            }
        }
        
        voucherViewModel.reloadTableViewClosure = { [weak self] in
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        voucherViewModel.initFetchById(address: address)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.set(visible: false, animated: true)
    }
    
    @IBAction func sendEmail(_ sender: Any) {
    }
    
    @IBAction func info(_ sender: Any) {
        if let url = URL(string: voucher.fund?.url_webshop ?? "") {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
}

extension MVoucherViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voucherViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TransactionTableViewCell
        
        cell.transaction = voucherViewModel.getCellViewModel(at: indexPath)
        
        return cell
    }
    
}
