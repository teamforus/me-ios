//
//  DarkMode_ActionButton.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 26.04.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

class DarkMode_ActionButton: ActionButton {
      
    override init(frame: CGRect) {
      super.init(frame: frame)
      setDarkModeButton()
    }
    
    var colorName: String = "Background_DarkTheme" {
      didSet {
        setSelectedColorName()
      }
    }
     
    var colorNameTitle: String = "Background_DarkTheme"{
        didSet {
            setSelectedColorNameTitle()
        }
    }
    
    required init(coder: NSCoder) {
      super.init(coder: coder)!
      setDarkModeButton()
    }
    
    func setDarkModeButton(){
      
      //self.setImage(image, for: .normal)
      if #available(iOS 11.0, *) {
        self.tintColor = UIColor(named: "Background_DarkTheme")
      } else {}
    }
    
    func setSelectedColorName() {
      if #available(iOS 11.0, *) {
        self.backgroundColor = UIColor(named: colorName)
      } else {}
    }
    
    func setSelectedColorNameTitle() {
      if #available(iOS 11.0, *) {
        self.setTitleColor(UIColor(named: colorNameTitle), for: .normal)
      } else {}
    }

}