//
//  User+CoreDataProperties.swift
//  Me-iOS
//
//  Created by Daniel Tcacenco on 12/20/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var accessToken: String?
    @NSManaged public var currentUser: Bool
    @NSManaged public var firstName: String?
    @NSManaged public var image: Data?
    @NSManaged public var lastName: String?
    @NSManaged public var pinCode: String?
    @NSManaged public var primaryEmail: String?

}
