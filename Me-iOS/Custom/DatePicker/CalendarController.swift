//
//  CalendarController.swift
//  Me-iOS
//
//  Created by Development Kingdom on 18.09.2020
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class CalendarController : UIViewController {
    
    
    lazy var customView : CustomDatePickerView = {
        let v = CustomDatePickerView()
        v.calendarController = self
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(customView)
        
        customView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.height.width.equalTo(380)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first?.view {
            if touch == self.view {
                dismiss(animated: true, completion: nil)
            }
        }
    }
}
