//
//  CornerImageView.swift
//  Me
//
//  Created by Tcacenco Daniel on 11/30/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit

@IBDesignable
class CornerImageView: UIImageView {
    
    @IBInspectable var selectedShadowColor : UIColor = UIColor.black {
        didSet {
            setSelectShadowColor()
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet {
            setCornerRadius()
        }
    }
    
    @IBInspectable var shadowOffset : CGSize = CGSize(width: 0, height: 0) {
        didSet {
            setShadowOffset()
        }
    }
    
    @IBInspectable var shadowOpacity : Float = 0 {
        didSet {
            setShadowOpacity()
        }
    }
    
    @IBInspectable var shadowRadius : CGFloat = 0 {
        didSet {
            setShadowRadius()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = false
        self.layer.masksToBounds = true
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        self.clipsToBounds = false
        self.layer.masksToBounds = true
    }
    
    func setCornerRadius(){
        self.layer.cornerRadius = cornerRadius
    }
    
    func setSelectShadowColor(){
        self.layer.shadowColor = selectedShadowColor.cgColor
    }
    
    func setShadowOffset(){
        self.layer.shadowOffset = shadowOffset
    }
    
    func setShadowOpacity(){
        self.layer.shadowOpacity = shadowOpacity
    }
    
    func setShadowRadius(){
        self.layer.shadowRadius = shadowRadius
    }

}
