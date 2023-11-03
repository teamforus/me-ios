//
//  Extension+UITextField.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 04.08.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

extension UITextField {

    func setPlaceholderColor(with text: String, and color: UIColor) {
        self.attributedPlaceholder =
        NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
        func setRightPaddingPoints(_ amount:CGFloat) {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
}

