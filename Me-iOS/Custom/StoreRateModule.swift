//
//  StoreRateModule.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 18.02.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

//
//  StoreRateModule.swift
//  Spark
//

import UIKit
import StoreKit

protocol StoreRateProtocol {
    func showAppRateIn(in viewController: UIViewController)
    
}

class StoreRateModule: NSObject, StoreRateProtocol {
    
    static let shared: StoreRateProtocol = StoreRateModule()
    
    func showAppRateIn(in viewController: UIViewController) {
        
        
        if !Preference.showAppRateHasSelected {
            if Preference.openAppCount == 8 {
                if Preference.monthHasPassed {
                    Preference.monthHasStarded = nil
                    Preference.openAppCount = 0
                }else {
                    if Preference.monthHasStarded == nil {
                        Preference.monthHasStarded = Date()
                    }
                }
            }else {
                let infoDictionaryKey = kCFBundleVersionKey as String
                let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
                if Preference.currentVersion != currentVersion {
                    if Preference.appRateWasShown {
                        
                        let allertController = UIAlertController(title: Localize.rate(), message: Localize.whould_you_like_to_rate(), preferredStyle: .alert)
                        
                        let yesAction = UIAlertAction(title: Localize.yes(), style: .default, handler: { alert -> Void in
                            Preference.showAppRateHasSelected = true
                            if #available(iOS 10.3, *) {
                                SKStoreReviewController.requestReview()
                            } else {}
                            Preference.currentVersion = currentVersion ?? ""
                        })
                        let cancelAction = UIAlertAction(title: Localize.cancel(), style: .cancel) { (action) in
                            Preference.openAppCount += 1
                        }
                        allertController.addAction(yesAction)
                        allertController.addAction(cancelAction)
                        viewController.present(allertController, animated: true)
                        
                    }else {
                        Preference.openAppCount += 1
                    }
                }
            }
        }
        
    }
}

