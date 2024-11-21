//
//  RecordsDataSource.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 24.05.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

class RecordsDataSource: NSObject {
    var records: [Record] = []
    var navigator: Navigator
    
    init(navigator: Navigator) {
        self.navigator = navigator
        super.init()
    }
}

extension RecordsDataSource: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordsTableViewCell.identifier, for: indexPath) as? RecordsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setup(records[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigator.navigate(to: .recordDetail(records[indexPath.row]))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
}
