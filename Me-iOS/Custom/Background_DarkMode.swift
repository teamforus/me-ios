//
//  Background_DarkMode.swift
//  Me-iOS
//
//  Created by mac on 7/15/20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class Background_DarkMode: UIView {

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
        self.backgroundColor = UIColor(named: "Background_DarkTheme")
      } else {
        // Fallback on earlier versions
      }
    }

}
