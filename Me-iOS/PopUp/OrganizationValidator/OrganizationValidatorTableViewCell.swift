//
//  OrganizationValidatorTableViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 10/21/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class OrganizationValidatorTableViewCell: UITableViewCell {
    @IBOutlet weak var imageOrganization: UILabel!
    @IBOutlet weak var organizationName: UILabel!
    
    var organization: EmployeesOrganization? {
        didSet{
            self.organizationName.text = organization?.organization?.name ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
