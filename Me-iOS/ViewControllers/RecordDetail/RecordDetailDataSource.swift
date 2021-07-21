//
//  RecordDetailDataSource.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 19.07.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

enum RecordDetailSectionType: Int, CaseIterable {
    case record
    case validations
}

class RecordDetailDataSource: NSObject {
    var record: Record

    init(record: Record) {
        self.record = record
        super.init()
    }
}

extension RecordDetailDataSource: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return RecordDetailSectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = RecordDetailSectionType.allCases[section]
        switch sections {
        case .record:
            return 1
            
        case .validations:
            return record.validations?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sections = RecordDetailSectionType.allCases[indexPath.section]
        switch sections {
        case .record:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordInfoTableViewCell.reuseIdentifier, for: indexPath) as? RecordInfoTableViewCell else {
                return UITableViewCell()
            }
            cell.setup(record)
            return cell
            
        case .validations:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ValidatorTableViewCell.reuseIdentifier, for: indexPath) as? ValidatorTableViewCell else {
                return UITableViewCell()
            }
            if let validator = record.validations?[indexPath.row] {
                cell.setup(validator)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sections = RecordDetailSectionType.allCases[indexPath.section]
        switch sections {
        case .record:
            return 180
            
        case .validations:
            return 110
        }
    }
}
