//
//  Extension+Array.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/28/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation


extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
