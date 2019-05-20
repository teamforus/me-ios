//
//  MVoucherViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import ISHPullUp

class MVouchersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    lazy var voucherViewModel: VouchersViewModel = {
        return VouchersViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CurrentSession.shared.token = UserDefaults.standard.string(forKey: "TOKEN")
        
        
        voucherViewModel.complete = { [weak self] (vouchers) in
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                if vouchers.count == 0 {
                    
                    self?.tableView.isHidden = true
                }else {
                    
                    self?.tableView.isHidden = false
                }
                
            }
        }
        
        voucherViewModel.initFetch()
        
    }
    
    
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToProduct" {
        
        let generalVC = didSetPullUP(storyBoardName: "ProductVoucher", segue: segue)
        (generalVC.contentViewController as! MProductVoucherViewController).address = self.voucherViewModel.selectedVoucher?.address ?? ""
        (generalVC.bottomViewController as! CommonBottomViewController).voucher = self.voucherViewModel.selectedVoucher
        (generalVC.bottomViewController as! CommonBottomViewController).qrType = .Voucher
            
        }else if segue.identifier == "goToVoucher" {
            
            let generalVC = didSetPullUP(storyBoardName: "Voucher", segue: segue)
            (generalVC.contentViewController as! MVoucherViewController).address = self.voucherViewModel.selectedVoucher?.address ?? ""
            (generalVC.bottomViewController as! CommonBottomViewController).voucher = self.voucherViewModel.selectedVoucher
            (generalVC.bottomViewController as! CommonBottomViewController).qrType = .Voucher
            
        }
     }
    
 
    
}

extension MVouchersViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voucherViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MWaletVoucherTableViewCell
        
        cell.voucher = voucherViewModel.getCellViewModel(at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        self.voucherViewModel.userPressed(at: indexPath)
        
        
        if voucherViewModel.isAllowSegue {
            if voucherViewModel.selectedVoucher?.product != nil {
                self.performSegue(withIdentifier: "goToProduct", sender: nil)
            }else {
                self.performSegue(withIdentifier: "goToVoucher", sender: nil)
            }
            return indexPath
        }else {
            return nil
        }
    }
}

extension UIViewController{
    
    func didSetPullUP(storyBoardName: String, segue: UIStoryboardSegue) -> CommonPullUpViewController {
        
        let storyBoard = UIStoryboard(name: storyBoardName , bundle: nil)
        let passVC = segue.destination as! CommonPullUpViewController
        
        passVC.contentViewController = storyBoard.instantiateViewController(withIdentifier: "content")
        
        passVC.bottomViewController = storyBoard.instantiateViewController(withIdentifier: "bottom")
        
        
        (passVC.bottomViewController as! CommonBottomViewController).pullUpController = passVC
        passVC.sizingDelegate = (passVC.bottomViewController as! CommonBottomViewController)
        passVC.stateDelegate = (passVC.bottomViewController as! CommonBottomViewController)
        
        return passVC
    }
}
