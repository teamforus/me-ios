//
//  EmployeesOrganization.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 10/18/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

struct EmployeesOrganization: Decodable {
    var id: Int?
    var identity_address: String?
    var organization_id: Int?
    var organization: Organization?
    var email: String?
}

struct OrganizationRecord: Codable{
    
    var organization_id: Int?
}
