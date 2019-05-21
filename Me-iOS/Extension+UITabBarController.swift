//
//  Extension+UITabBarController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/21/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit


extension UITabBarController {
    
    func set(visible: Bool, animated: Bool, completion: ((Bool)->Void)? = nil ) {
        
        guard isVisible() != visible else {
            completion?(true)
            return
        }
        
        let offsetY = tabBar.frame.size.height
        let duration = (animated ? 0.3 : 0.0)
        
        let beginTransform:CGAffineTransform
        let endTransform:CGAffineTransform
        
        if visible {
            beginTransform = CGAffineTransform(translationX: 0, y: offsetY)
            endTransform = CGAffineTransform.identity
        } else {
            beginTransform = CGAffineTransform.identity
            endTransform = CGAffineTransform(translationX: 0, y: offsetY)
        }
        
        tabBar.transform = beginTransform
        if visible {
            tabBar.isHidden = false
        }
        
        UIView.animate(withDuration: duration, animations: {
            self.tabBar.transform = endTransform
        }, completion: { compete in
            completion?(compete)
            if !visible {
                self.tabBar.isHidden = true
            }
        })
    }
    
    func isVisible() -> Bool {
        return !tabBar.isHidden
    }
}
