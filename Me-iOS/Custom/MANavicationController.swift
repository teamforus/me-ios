//
//  MANavicationController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/23/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MANavicationController: NSObject {
    
    fileprivate weak var navigationController: UINavigationController?
    
    init(controller: UINavigationController) {
        self.navigationController = controller
        
        super.init()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

extension MANavicationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (navigationController?.viewControllers.count ?? 0) > 1
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}


class HiddenNavBarNavigationController: UINavigationController {
    
    // MARK: - Properties
    
    private var popRecognizer: MANavicationController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopRecognizer()
    }
    
    // MARK: - Setup
    
    private func setupPopRecognizer() {
        popRecognizer = MANavicationController(controller: self)
    }
}
