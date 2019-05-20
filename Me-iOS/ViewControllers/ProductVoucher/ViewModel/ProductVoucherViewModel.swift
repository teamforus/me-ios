//
//  ProductVoucherViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

class ProductVoucherViewModel{
    
    var commonServices: CommonServiceProtocol!
    
    var complete: ((Voucher)->())?
    
    init(commonServices: CommonServiceProtocol = CommonService()) {
        self.commonServices = commonServices
    }
    
    func initFetchById(address: String){
        
        commonServices.getById(request: "platform/vouchers/", id: address, complete: { (response: ResponseData<Voucher>, statusCode) in

            self.complete!(response.data!)

        }, failure: { (error) in
            print(error)
        })
        
    }
    
}
