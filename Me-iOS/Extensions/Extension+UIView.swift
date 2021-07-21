//
//  Extension+UIView.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 10.07.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

extension UIView {
    
    func showAnimate()
    {
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.isHidden = false
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alpha = 0.0
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.isHidden = true
            }
        });
    }
}

extension UIView {
    
    func setupShadow(offset: CGSize = CGSize(width: 0, height: 0), radius: CGFloat, opacity: Float, color: CGColor) {
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
        self.layer.shadowColor = color
    }
}

extension UIView {
    func colorName(_ colorName: String) {
        if #available(iOS 11.0, *) {
          self.backgroundColor = UIColor(named: colorName)
        } else {}
    }
}

extension UIView {
    func rounded(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
    
    var corner: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            rounded(cornerRadius: newValue)
        }
    }
}

