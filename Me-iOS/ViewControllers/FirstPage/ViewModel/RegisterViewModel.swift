//
//  RegisterViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation


class RegisterViewModel{
    
    var registerService: LoginServiceProtocol!
    
    init(registerService: LoginServiceProtocol = LoginService()) {
        self.registerService = registerService
    }
    
    var complete: ((Register, Int)->())!
    
    func initRegister(identity: Identity){
        
        registerService.register(indentity: identity, complete: { (response, statusCode) in
            
            self.complete(response, statusCode)
            
        }) { (error) in
            self.complete(Register(message: nil, errors: nil, accessToken: nil, success: nil), 500)
        }
    }
    
}
