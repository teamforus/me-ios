//
//  ValidatorTableViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/27/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class ValidatorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var organizationName: UILabel!
    @IBOutlet weak var nameValidator: UILabel!
    @IBOutlet weak var descriptionValidator: UILabel!
    @IBOutlet weak var iconValidator: UIImageView!
    var validator: Validator!{
        didSet{
            if descriptionValidator != nil {
                
                self.nameValidator.text = validator.organization?.name ?? ""
                self.descriptionValidator.text = validator.identity_address ?? ""
                
            }else {
                
                self.nameValidator.text = validator.identity_address ?? ""
                
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
