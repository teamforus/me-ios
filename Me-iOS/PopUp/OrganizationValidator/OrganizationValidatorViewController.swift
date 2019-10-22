//
//  OrganizationValidatorViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 10/21/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

protocol OrganizationValidatorViewControllerDelegate: class {
    func close()
    func selectOrganization(organization: EmployeesOrganization)
}

class OrganizationValidatorViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bodyView: CustomCornerUIView!
    @IBOutlet weak var bottomConstraintView: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    weak var delegate: OrganizationValidatorViewControllerDelegate!
    var recordEmployeesOrganizations: [EmployeesOrganization] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "OrganizationValidatorTableViewCell", bundle: nil), forCellReuseIdentifier: "OrganizationValidatorTableViewCell")
        self.bottomConstraintView.constant = -600
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.bottomConstraintView.constant = -12
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    @IBAction func close(_ sender: UIButton){
        bottomConstraintView.constant = -1000
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (isFinished) in
            self.view.removeFromSuperview()
            self.delegate.close()
        })
    }
    
}

extension OrganizationValidatorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordEmployeesOrganizations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrganizationValidatorTableViewCell", for: indexPath) as! OrganizationValidatorTableViewCell
        
        cell.organization = recordEmployeesOrganizations[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.selectOrganization(organization: recordEmployeesOrganizations[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !tableView.isCellVisible(section: 0, row: recordEmployeesOrganizations.count - 1) {
            heightConstraint.constant = self.view.frame.size.height
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

extension UITableView {
    func isCellVisible(section:Int, row: Int) -> Bool {
        guard let indexes = self.indexPathsForVisibleRows else {
            return false
        }
        return indexes.contains {$0.section == section && $0.row == row }
    }  }
