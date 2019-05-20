//
//  MProductVoucherViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import MapKit

class MProductVoucherViewController: UIViewController {
    @IBOutlet weak var productNameLabel: PausedMarqueLabel!
    @IBOutlet weak var organizationNameLabel: UILabel!
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var organizationProductName: UILabel!
    @IBOutlet weak var addressLabel: PausedMarqueLabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var organizationIcon: CornerImageView!
    
    
    var address: String!
    lazy var productViewModel: ProductVoucherViewModel = {
        return ProductVoucherViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        productViewModel.complete = { [weak self] (voucher) in
            
            DispatchQueue.main.async {
                
                self?.productNameLabel.text = voucher.product?.name ?? ""
                self?.organizationNameLabel.text = voucher.fund?.organization?.name ?? ""
                self?.organizationProductName.text = voucher.product?.organization?.name ?? ""
                self?.addressLabel.text = voucher.offices?.first?.address ?? ""
                self?.phoneNumberLabel.text = voucher.offices?.first?.phone ?? ""
                self?.emailButton.setTitle(voucher.offices?.first?.organization?.email, for: .normal)
                self?.organizationIcon.loadImageUsingUrlString(urlString: voucher.product?.organization?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
                
                
                
            }
            
        }
        
        productViewModel.initFetchById(address: address)
    }
    

    
    @IBAction func sendByEmail(_ sender: Any) {
    }
    
    @IBAction func info(_ sender: Any) {
    }
    
    

}
