//
//  CustomImageView.swift
//  PentalogTest
//
//  Created by Tcacenco Daniel on 3/26/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

let imageChache = NSCache<AnyObject, AnyObject>()

class DownloadImage: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString( urlString: String, placeHolder: UIImage){
        let url = URL(string: urlString)
        
        image = nil
        
        if let imageFromCache = imageChache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    self.image = placeHolder
                }
                
                return
            }
            
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                imageChache.setObject(imageChache, forKey: urlString as AnyObject)
                self.image = imageToCache
            }
            
            }.resume()
    }
    
}
