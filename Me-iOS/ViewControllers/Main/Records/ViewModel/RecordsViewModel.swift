//
//  RecordsViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation


class RecordsViewModel{
    
    var commonService: CommonServiceProtocol!
    
    private var cellViewModels: [Record] = [Record]() {
        didSet {
            complete?(cellViewModels)
        }
    }
    
    var complete: (([Record])->())?
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    func initFitch(){
        
        commonService.get(request: "identity/records", complete: { (response: [Record], statusCode) in
            
            self.processFetchedLunche(records: response)
            
        }) { (error) in
            
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> Record {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( record: Record ) -> Record {
        
        return record
    }
    
    private func processFetchedLunche( records: [Record] ) {
        var vms = [Record]()
        for record in records {
            
            vms.append( createCellViewModel(record: record) )
        }
        self.cellViewModels = vms
    }
}
