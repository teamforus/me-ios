//
//  MProductVoucherViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class MProductVoucherViewController: UIViewController {
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var organizationNameLabel: UILabel!
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var organizationProductName: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var organizationIcon: CornerImageView!
    
    @IBOutlet var labeles: [SkeletonView]!
    @IBOutlet var images: [SkeletonUIImageView]!
    var address: String!
    var voucher: Voucher!
    lazy var productViewModel: ProductVoucherViewModel = {
        return ProductVoucherViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labeles.forEach { (view) in
            view.startAnimating()
        }
        
        images.forEach { (view) in
            view.startAnimating()
        }
        productViewModel.complete = { [weak self] (voucher) in
            
            DispatchQueue.main.async {
                
                self?.productNameLabel.text = voucher.product?.name ?? ""
                self?.organizationNameLabel.text = voucher.fund?.organization?.name ?? ""
                self?.organizationProductName.text = voucher.product?.organization?.name ?? ""
                self?.addressLabel.text = voucher.offices?.first?.address ?? ""
                self?.phoneNumberLabel.text = voucher.offices?.first?.phone ?? ""
                self?.emailButton.setTitle(voucher.offices?.first?.organization?.email, for: .normal)
                self?.organizationIcon.loadImageUsingUrlString(urlString: voucher.product?.organization?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
                self?.qrCodeImage.generateQRCode(from: "{\"type\": \"voucher\",\"value\": \"\(voucher.address ?? "")\" }")
                self?.voucher = voucher
                
                self?.labeles.forEach { (view) in
                    view.stopAnimating()
                }
                self?.images.forEach { (view) in
                    view.stopAnimating()
                }
                
            }
            
        }
        
        productViewModel.initFetchById(address: address)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.set(visible: false, animated: true)
    }
    
    @IBAction func sendByEmail(_ sender: Any) {
    }
    
    @IBAction func info(_ sender: Any) {
        if let url = URL(string: "\(voucher.fund?.url_webshop ?? "")product/\(voucher.product?.id ?? 0)") {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    
}
