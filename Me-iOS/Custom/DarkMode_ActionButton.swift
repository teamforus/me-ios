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
        self.tintColor = UIColor(named: "Background_DarkTheme")
    }
    
    func setSelectedColorName() {
        self.backgroundColor = UIColor(named: colorName)
    }
    
    func setSelectedColorNameTitle() {
        self.setTitleColor(UIColor(named: colorNameTitle), for: .normal)
    }

}
