//
//  MVoucherViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
}
