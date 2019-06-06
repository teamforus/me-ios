//
//  MRecordDetailViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/27/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MRecordDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recordTypeLabel: UILabel!
    @IBOutlet weak var recordValue: UILabel!
    
    var recordId: String!
    var record: Record!
    lazy var recordDetailViewModel: RecordDetailViewModel = {
        return RecordDetailViewModel()
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordDetailViewModel.complete = { [weak self] (record) in
            
            DispatchQueue.main.async {
                
                self?.record = record
                
                self?.recordTypeLabel.text = record.key?.replacingOccurrences(of: "_", with: " ").capitalized
                self?.recordValue.text = record.value
                self?.tableView.reloadData()
                
                if self?.recordDetailViewModel.numberOfCells == 0{
                    
                    self?.tableView.isHidden = true
                    
                }else {
                    
                    self?.tableView.isHidden = false
                    
                }
            }
        }
        
        recordDetailViewModel.initFetchById(id: recordId)
        
        recordDetailViewModel.completeDelete = { [weak self] (statusCode) in
            
            DispatchQueue.main.async {
                
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    @IBAction func showQRCode(_ sender: Any) {
        NotificationCenter.default.post(name: NotificationName.TogleStateWindow, object: nil)
    }
    
    @IBAction func deleteRecord(_ sender: UIButton) {
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Peer-top-peer validations"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ValidatorTableViewCell
        
        cell.validator = recordDetailViewModel.getCellViewModel(at: indexPath)
        
        return cell
    }
}
