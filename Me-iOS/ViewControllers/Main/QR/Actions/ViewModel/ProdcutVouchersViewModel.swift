//
//  ProdcutVouchersViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 16.02.22.
//  Copyright © 2022 Tcacenco Daniel. All rights reserved.
//

import Foundation

class ProdcutVouchersViewModel {
    var commonService: CommonServiceProtocol!
    var lastPage: Int?
    var currentPage: Int?
    var nextPage: String?
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    private var cellViewModels: [Voucher] = [Voucher]() {
        didSet {
            complete?(cellViewModels)
        }
    }
    
    var complete: (([Voucher])->())?
    
    func fetchSubsidies(voucherAddress: String, organizationId: String) {
        let request = "platform/provider/vouchers/" + voucherAddress + "/product-vouchers?organization_id=\(organizationId)"
        commonService.get(request: request, complete: { (response: ResponseDataArray<Voucher>, statusCode) in
            self.processFetchedLunche(subsidies: response.data ?? [])
            self.lastPage = response.meta?.last_page ?? 0
            self.currentPage = response.meta?.current_page ?? 0
            self.nextPage = response.links?.next ?? ""
        }) { (error) in
            
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> Voucher {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( subsidie: Voucher ) -> Voucher {
        
        return subsidie
    }
    
    private func processFetchedLunche( subsidies: [Voucher] ) {
        var vms = [Voucher]()
        for subsidie in subsidies {
            vms.append( createCellViewModel(subsidie: subsidie))
        }
        self.cellViewModels = vms
    }
}
