//
//  OrganizationTableViewCell.swift
//  Me
//
//  Created by Tcacenco Daniel on 12/19/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit



protocol OrganizationTableViewCellDelegate: class {
    func didSelectAllowedOrganization(organization: AllowedOrganization)
}

class OrganizationTableViewCell: UITableViewCell {
    @IBOutlet var organizationImageView: UIImageView!
    @IBOutlet var organizationNameLabel: UILabel!
    weak var delegate: OrganizationTableViewCellDelegate!
    var allowedOrganization: AllowedOrganization? {
        didSet{
            
                self.organizationImageView.loadImageUsingUrlString(urlString: allowedOrganization?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
            
            self.organizationNameLabel.text = allowedOrganization?.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func selectOrganization(_ sender: Any) {
            delegate.didSelectAllowedOrganization(organization: allowedOrganization!)
        
    }
    
}
