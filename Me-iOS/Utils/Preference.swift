//
//  Preference.swift
//  Me-iOS
//
//  Created by Development Kingdom on 23.09.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import Foundation

class Preference {
    
    public static var tapToSeeTransactionTipHasShown: Bool {
        get {
            return tapToSeeTransactionTipHasShownCount == 1
        }
        set {
            if newValue {
                tapToSeeTransactionTipHasShownCount = tapToSeeTransactionTipHasShownCount + 1
            } else {
                tapToSeeTransactionTipHasShownCount = tapToSeeTransactionTipHasShownCount - 1
            }
        }
    }
    
    private static var tapToSeeTransactionTipHasShownCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsName.tapToSeeTransactionTipHasShownCount)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsName.tapToSeeTransactionTipHasShownCount)
        }
    }
    
    public static var userHasCloseUpdateNotifier: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsName.userHasCloseUpdateNotifier)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsName.userHasCloseUpdateNotifier)
        }
    }
    
    public static var openAppCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsName.openAppCount)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsName.openAppCount)
        }
    }
    
    public static var appRateWasShown: Bool {
        get {
            return openAppCount == 3 || openAppCount == 5 || openAppCount == 7
        }
    }
    
    public static var showAppRateHasSelected: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsName.showAppRateHasSelected)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsName.showAppRateHasSelected)
        }
    }
    
    public static var currentVersion: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsName.lastVersionPromptedForReviewKey) ?? ""
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsName.lastVersionPromptedForReviewKey)
        }
    }
    
    
    
    public static var monthHasStarded: Date? {
        get {
            return UserDefaults.standard.value(forKey: UserDefaultsName.monthHasStarded) as? Date
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsName.monthHasStarded)
        }
    }
    
    public static var monthHasPassed: Bool {
        get {
            if let date = Preference.monthHasStarded {
                if Calendar.current.dateComponents([.month], from: date, to: Date()).month == 1 {
                    return true
                }
            }
            return false
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsName.monthHasStarded)
        }
    }
}
