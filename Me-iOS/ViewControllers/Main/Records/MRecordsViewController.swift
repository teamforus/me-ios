//
//  MRecordsViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import BWWalkthrough

class MRecordsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    lazy var recordViewModel: RecordsViewModel = {
        return RecordsViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(walkthroughCloseButtonPressed), name: NotificationName.ClosePageControll, object: nil)
        
        recordViewModel.complete = { [weak self] (records) in
            
            DispatchQueue.main.async {
                
                self?.tableView.reloadData()
                
            }
        }
    }
    
    @IBAction func createRecord(_ sender: UIButton) {
        
        var stb = UIStoryboard(name: "ChooseTypeRecord", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
        let pageOne = stb.instantiateViewController(withIdentifier: "types")
        stb = UIStoryboard(name: "TextRecord", bundle: nil)
        let pageTwo = stb.instantiateViewController(withIdentifier: "text")
        
        walkthrough.delegate = self
        walkthrough.scrollview.isScrollEnabled = false
        walkthrough.add(viewController:pageOne)
        walkthrough.add(viewController:pageTwo)
        
        self.present(walkthrough, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setStatusBarStyle(.default)
        self.tabBarController?.set(visible: true, animated: true)
        recordViewModel.initFitch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToRecordDetail" {
        
        let record = recordViewModel.selectedRecord
        let generalVC = didSetPullUP(storyBoardName: "RecordDetail", segue: segue)
        (generalVC.contentViewController as! MRecordDetailViewController).recordId =  String(record?.id ?? 0)
        (generalVC.bottomViewController as! CommonBottomViewController).qrType = .Record
        (generalVC.bottomViewController as! CommonBottomViewController).idRecord = record?.id ?? 0
            
        }
        
    }
    
}

extension MRecordsViewController: BWWalkthroughViewControllerDelegate{
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        if pageNumber == 3{
            NotificationCenter.default.post(name: Notification.Name("HidePageNumber"), object: nil)
        }
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        self.recordViewModel.userPressed(at: indexPath)
        if recordViewModel.isAllowSegue {
            return indexPath
        }else {
            return nil
        }
    }
}

