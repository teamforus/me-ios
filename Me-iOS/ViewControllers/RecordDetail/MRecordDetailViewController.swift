//
//  MRecordDetailViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/27/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import KVSpinnerView

class MRecordDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recordTypeLabel: UILabel!
    @IBOutlet weak var recordValue: UILabel!
    @IBOutlet weak var borderView: CustomCornerUIView!
    @IBOutlet weak var validationCount: UILabel!
    @IBOutlet weak var validationsLabel: UILabel!
    
    var recordId: String!
    var record: Record!
    lazy var recordDetailViewModel: RecordDetailViewModel = {
        return RecordDetailViewModel()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordDetailViewModel.vc = self
        
        recordDetailViewModel.complete = { [weak self] (record) in
            
            DispatchQueue.main.async {
                
                self?.record = record
                
                self?.recordTypeLabel.text = record.name ?? ""
                self?.recordValue.text = record.value
                if record.validations?.count != 0 {
                    self?.validationCount.text = "\(record.validations!.count)"
                    self?.validationCount.isHidden = false
                    self?.validationsLabel.isHidden = false
                }else {
                    self?.validationCount.isHidden = true
                    self?.validationsLabel.isHidden = true
                }
                self?.tableView.reloadData()
                
                if self?.recordDetailViewModel.numberOfCells == 0{
                    
                    self?.tableView.isHidden = true
                    
                }else {
                    
                    self?.tableView.isHidden = false
                    
                }
                KVSpinnerView.dismiss()
            }
        }
        
        
        if isReachable() {
            
            KVSpinnerView.show()
            recordDetailViewModel.initFetchById(id: recordId)
            
        }else {
            
            showInternetUnable()
            
        }
        
        recordDetailViewModel.completeDelete = { [weak self] (statusCode) in
            
            DispatchQueue.main.async {
                
                KVSpinnerView.dismiss()
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    @IBAction func showQRCode(_ sender: Any) {
        let popOverVC = PullUpQRViewController(nibName: "PullUpQRViewController", bundle: nil)
        popOverVC.idRecord = Int(recordId)
        popOverVC.record = record
        popOverVC.qrType = .Record
        showPopUPWithAnimation(vc: popOverVC)
    }
    
    @IBAction func deleteRecord(_ sender: UIButton) {
        KVSpinnerView.show()
        recordDetailViewModel.initDeleteById(id: recordId)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recordValidatorVC = segue.destination as? MRecordValidatorsViewController {
            recordValidatorVC.record = self.record
        }
    }
    
}

extension MRecordDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordDetailViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ValidatorTableViewCell
        
        cell.validator = recordDetailViewModel.getCellViewModel(at: indexPath)
        
        return cell
    }
}
