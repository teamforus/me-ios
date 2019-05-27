//
//  MRecordsViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MRecordsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    lazy var recordViewModel: RecordsViewModel = {
        return RecordsViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordViewModel.complete = { [weak self] (records) in
            
            DispatchQueue.main.async {
                
                self?.tableView.reloadData()
                
            }
        }
        
           recordViewModel.initFitch()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
     
    }

}

extension MRecordsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecordsTableViewCell
        
        cell.record = recordViewModel.getCellViewModel(at: indexPath)
        
        
        return cell
    }
}
