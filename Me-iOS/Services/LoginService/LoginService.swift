//
//  LoginService.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/6/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation


protocol LoginServiceProtocol {
    
    //    func login(complete: @escaping (_ loginUser: LoginUser)->() )
    
    func register(indentity: Identity, complete: @escaping(Register, Int)->(), failure: @escaping(Error)->())
    
}

class LoginService: LoginServiceProtocol{
    
    func register(indentity: Identity, complete: @escaping (Register, Int) -> (), failure: @escaping (Error) -> ()) {
        
        let url = URL(string: BaseURL.baseURL(url: "identity"))!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("me_app-ios", forHTTPHeaderField: "Client-Type")
        request.addValue("general", forHTTPHeaderField: "Client-Key")
        
        let parameters = ["email" : indentity.email ?? ""] as [String : Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch let error {
            failure(error)
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                failure(error)
                return
            }

            guard let data = data else {
                failure(NSError(domain: "LoginService", code: -1))
                return
            }

            let decoder = JSONDecoder()
            do {
                
                let responseData = try decoder.decode(Register.self, from: data)
                guard let httpResponse = response as? HTTPURLResponse else {
                    failure(NSError(domain: "LoginService", code: -1))
                    return
                }
                
                complete(responseData, httpResponse.statusCode)
            } catch let error {
                
                failure(error)
                
            }
        }
        
        task.resume()
    }
    
    
}
