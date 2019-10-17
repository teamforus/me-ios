//
//  CheckWebsiteReacheble.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 10/17/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

struct CheckWebSiteReacheble{
    
    static func checkWebsite(url: String,completion: @escaping (Bool) -> Void ) {
        guard let url = URL(string: url) else { return }

        var request = URLRequest(url: url)
        request.timeoutInterval = 1.0

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("\(error.localizedDescription)")
                completion(false)
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
                completion(true)

            }
        }
        task.resume()
    }
}
