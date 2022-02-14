//
//  Extension+UIImageView.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/13/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import EFQRCode

extension UIImageView{
    func generateQRCode(from string: String)  {
        if let image = EFQRCode.generate(
            for: string,
               watermark: UIImage(named: "me-logo")?.cgImage
        ) {
            self.image = UIImage(cgImage: image)
        } else {
            print("Create QRCode image failed!")
        }
    }
}
