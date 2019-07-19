//
//  RecordValidatorsViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/28/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

class RecordValidatorsViewModel {
    
    var commonService: CommonServiceProtocol!
    var selectedValidator: Validator?
    var isAllowSegue: Bool = false
    private var cellViewModels: [Validator] = [Validator]() {
        didSet{
            self.reloadDataTableView?()
        }
    }
    
    var reloadDataTableView: (()->())?
    var confirValidation: ((Int)->())?
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    func initFecth() {
        
        commonService.get(request: "platform/validators", complete: { (response: ResponseDataArray<Validator>, statusCode) in
            
            self.processFetchedLunche(validators: response.data ?? [])
            
        }) { (error) in
            
        }
    }
    
    func initValidateRecord(validatorId: Int, recordId: Int ){
        let parameters = ["validator_id" : validatorId,
                          "record_id" : recordId]
        commonService.postWithParameters(request: "platform/validator-requests", parameters: parameters, complete: { (response: ResponseData<Validator>, statusCode) in
            
            self.confirValidation?(statusCode)
            
        }) { (error) in
            
        }
        
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> Validator {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( validator: Validator ) -> Validator {
        
        return validator
    }
    
    private func processFetchedLunche( validators: [Validator] ) {
        var vms = [Validator]()
        for validator in validators {
            
            vms.append( createCellViewModel(validator: validator) )
        }
        
        self.cellViewModels = vms.removingDuplicates()
    }
}

extension RecordValidatorsViewModel {
    
    func userPressed( at indexPath: IndexPath) {
        let validator = self.cellViewModels[indexPath.row]
        self.isAllowSegue = true
        self.selectedValidator = validator
    }
}
