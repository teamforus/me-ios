//
//  BackButton_DarkMode.swift
//  Me-iOS
//
//  Created by mac on 7/14/20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class BackButton_DarkMode: ActionButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setDarkModeButton()
  }
  
  required init(coder: NSCoder) {
    super.init(coder: coder)!
    setDarkModeButton()
  }
  
  func setDarkModeButton(){
    let image = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
    self.setImage(image, for: .normal)
    if #available(iOS 11.0, *) {
      self.tintColor = UIColor(named: "Black_Light_DarkTheme")
    } else {
      // Fallback on earlier versions
    }
  }
  
}
