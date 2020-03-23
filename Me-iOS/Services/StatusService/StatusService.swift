//
//  StatusService.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/13/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

protocol StatusServiceProtocol{
    
     func checkStatus(token:String ,complete: @escaping (_ response: AuthorizationQRToken,_ statusCode: Int)->(), failute: @escaping(_ error: Error)->() )
}

class StatusService: StatusServiceProtocol{
    
    func checkStatus(token: String, complete: @escaping (AuthorizationQRToken, Int) -> (), failute: @escaping (Error) -> ()) {
        var request = URLRequest(url: URL(string: BaseURL.baseURL(url: "identity/proxy/check-token"))!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("me_app-ios", forHTTPHeaderField: "Client-Type")
        request.addValue(token, forHTTPHeaderField: "Access-Token")
        
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                
                let responseData = try decoder.decode( AuthorizationQRToken.self, from: data)
                let httpStatus = response as! HTTPURLResponse
                complete(responseData, httpStatus.statusCode)
                
            } catch let jsonError {
                failute(jsonError)
            }
        }
        
        task.resume()
    }
}
