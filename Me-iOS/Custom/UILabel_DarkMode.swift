//
//  UILabel_DarkMode.swift
//  Me-iOS
//
//  Created by mac on 7/15/20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class UILabel_DarkMode: UILabel {

  override init(frame: CGRect) {
      super.init(frame: frame)
      setDarkModeBackground()
    }
    
    required init(coder: NSCoder) {
      super.init(coder: coder)!
      setDarkModeBackground()
    }
    
    func setDarkModeBackground(){
      if #available(iOS 11.0, *) {
        self.textColor = UIColor(named: "Background_DarkTheme")
      } else {
        // Fallback on earlier versions
      }
    }
}
