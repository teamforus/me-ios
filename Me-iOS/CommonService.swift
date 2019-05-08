//
//  CommonService.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/6/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

protocol CommonServiceProtocol {
    func get<T: Decodable> (url: String, completion: @escaping (_ response: T) -> ())
    func getById<T: Decodable> (url: String, id: String, completion: @escaping (_ response: T) -> ())
}


class CommonService: CommonServiceProtocol {
    
    
    func get<T>(url: String, completion: @escaping (T) -> ()) where T : Decodable {
        
        var request = URLRequest(url: URL(string: BaseURL.baseURL(url: url))!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer " + CurrentSession.shared.token, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                
                let responseData = try decoder.decode( T.self, from: data)
                let httpStatus = response as? HTTPURLResponse
//                complete(responseData, httpStatus!.statusCode)
            } catch {}
        }
        
        task.resume()
    }
    
    func getById<T>(url: String, id: String, completion: @escaping (T) -> ()) where T : Decodable {
        
        var request = URLRequest(url: URL(string: BaseURL.baseURL(url: url + id))!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer " + CurrentSession.shared.token, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                
                let responseData = try decoder.decode( T.self, from: data)
                let httpStatus = response as? HTTPURLResponse
//                complete(responseData, httpStatus!.statusCode)
            } catch {}
        }
        
        task.resume()
    }
}


