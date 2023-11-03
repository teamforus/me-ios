//
//  TransactionViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 16.09.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class TransactionViewModel {

 var commonService: CommonServiceProtocol!
    var vc: UIViewController!
    
    private var cellViewModels: [Transaction] = [Transaction]() {
        didSet {
            complete?(cellViewModels)
        }
    }
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    var complete: (([Transaction])->())?
    
    var nextPage: String?
    
    func initFetch(){
        
        commonService.get(request: "platform/provider/transactions", complete: { (response: ResponseDataArray<Transaction>, statusCode) in
            if statusCode == 503 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showErrorServer()
                }
                
            }else if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: Localize.expired_session(), message: Localize.your_session_has_expired(), okAction: UIAlertAction(title: Localize.log_out(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            } else {
                self.nextPage = response.links?.next
                self.processFetchedLunche(transactions: response.data ?? [])
            }
            
        }, failure: { (error) in
            DispatchQueue.main.async {
                KVSpinnerView.dismiss()
            }
        })
        
    }
    
    func didGetTransaction(by page: String) {
        let pageLink = page.replacingOccurrences(of: "https://\(BaseURL.getBaseURL())/api/v1/", with: "")
        commonService.get(request: pageLink, complete: { (response: ResponseDataArray<Transaction>, statusCode) in
            if statusCode == 503 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showErrorServer()
                }
                
            }else if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: Localize.expired_session(), message: Localize.your_session_has_expired(), okAction: UIAlertAction(title: Localize.log_out(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            } else {
                self.nextPage = response.links?.next
                self.fetchNewData(transactions: response.data ?? [])
            }
            
        }, failure: { (error) in
            DispatchQueue.main.async {
                KVSpinnerView.dismiss()
            }
        })
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> Transaction {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( transaction: Transaction ) -> Transaction {
        
        return transaction
    }
    
    private func processFetchedLunche( transactions: [Transaction] ) {
        var vms = [Transaction]()
        for transaction in transactions {
            vms.append( createCellViewModel(transaction: transaction))
        }
        self.cellViewModels = vms
    }
    
    private func fetchNewData(transactions: [Transaction]) {
        transactions.forEach { transaction in
//            self.patients.append(transaction)
            self.cellViewModels.append(transaction)
        }
    }
    
    func sortTransactionByDate(form date: Date) {
        commonService.get(request: "platform/provider/transactions?from=" + date.dateFormaterForServer(), complete: { (response: ResponseDataArray<Transaction>, statusCode) in
            if statusCode == 503 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showErrorServer()
                }
                
            }else if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: Localize.expired_session(), message: Localize.your_session_has_expired(), okAction: UIAlertAction(title: Localize.log_out(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            } else {
                
                self.processFetchedLunche(transactions: response.data ?? [])
            }
            
        }, failure: { (error) in
            DispatchQueue.main.async {
                KVSpinnerView.dismiss()
            }
        })
    }
}
