//
//  MVoucherViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import ISHPullUp
import KVSpinnerView

class MVouchersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    var isFromLogin: Bool!
    
    lazy var voucherViewModel: VouchersViewModel = {
        return VouchersViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForPreviewing(with: self, sourceView: tableView)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        if isFromLogin != nil {
            self.showPopUPWithAnimation(vc: MCrashConfirmViewController(nibName: "MCrashConfirmViewController", bundle: nil))
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        voucherViewModel.complete = { [weak self] (vouchers) in
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                if vouchers.count == 0 {
                    
                    self?.tableView.isHidden = true
                }else {
                    
                    self?.tableView.isHidden = false
                }
                KVSpinnerView.dismiss()
                self?.refreshControl.endRefreshing()
            }
        }
        
        initFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setStatusBarStyle(.default)
        self.tabBarController?.set(visible: true, animated: true)
    }
    
    func initFetch() {
        
        if isReachable() {
            
            KVSpinnerView.show()
            voucherViewModel.vc = self
            voucherViewModel.initFetch()
            
        }else {
            
            showInternetUnable()
        }
    }
    
    @objc func refreshData(_ sender: Any) {
        initFetch()
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
    
    func didSetPullUPWithoutSegue(storyBoardName: String, isProduct: Bool) -> CommonPullUpViewController {
        
        let storyBoard = UIStoryboard(name: storyBoardName , bundle: nil)
        let passVC = storyBoard.instantiateViewController(withIdentifier: "general") as! CommonPullUpViewController
        
        passVC.contentViewController = storyBoard.instantiateViewController(withIdentifier: "content")
        
        passVC.bottomViewController = storyBoard.instantiateViewController(withIdentifier: "bottom")
        
        (passVC.bottomViewController as! CommonBottomViewController).pullUpController = passVC
        passVC.sizingDelegate = (passVC.bottomViewController as! CommonBottomViewController)
        
        if isProduct {
            
            (passVC.contentViewController as! MProductVoucherViewController).address = self.voucherViewModel.selectedVoucher?.address ?? ""
        }else {
            
            (passVC.contentViewController as! MVoucherViewController).address = self.voucherViewModel.selectedVoucher?.address ?? ""
            
        }
        passVC.stateDelegate = (passVC.bottomViewController as! CommonBottomViewController)
        (passVC.bottomViewController as! CommonBottomViewController).voucher = self.voucherViewModel.selectedVoucher
        (passVC.bottomViewController as! CommonBottomViewController).qrType = .Voucher
        
        return passVC
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VoucherTableViewCell
        
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

extension MVouchersViewController: UIViewControllerPreviewingDelegate{
    
    private func createDetailViewControllerIndexPath(vc: UIViewController, indexPath: IndexPath) -> UIViewController {
        
        let detailViewController = vc
        
        return detailViewController
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: location) else {
            return nil
        }
        
        self.voucherViewModel.userPressed(at: indexPath)
        var detailViewController = UIViewController()
        if voucherViewModel.selectedVoucher?.product != nil {
            detailViewController = createDetailViewControllerIndexPath(vc: didSetPullUPWithoutSegue(storyBoardName: "ProductVoucher", isProduct: true),
                                                                       indexPath: indexPath)
        }else {
            detailViewController = createDetailViewControllerIndexPath(vc: didSetPullUPWithoutSegue(storyBoardName: "Voucher", isProduct: false),
                                                                       indexPath: indexPath)
        }
        
        
        
        return detailViewController
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
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
