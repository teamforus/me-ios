//
//  RecordDetailViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/27/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation


struct RecordDetailViewModel {
    
    var commonService: CommonServiceProtocol!
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    func initFetchById(id: String){
        
        commonService.getById(request: "", id: id, complete: { (response: Record, statusCode) in
            
        }) { (error) in
            
        }
        
    }
}
