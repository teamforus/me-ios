//
//  PausedMarqueLabel.swift
//  Me
//
//  Created by Tcacenco Daniel on 12/3/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit
import MarqueeLabel

class PausedMarqueLabel: MarqueeLabel {

    required init(coder: NSCoder) {
        super.init(coder: coder)!
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(pauseTap))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func pauseTap(_ recognizer: UIGestureRecognizer) {
        let label = recognizer.view as! MarqueeLabel
        if recognizer.state == .ended {
            label.isPaused ? label.unpauseLabel() : label.pauseLabel()
        }
    }
    
}
