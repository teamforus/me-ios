//
//  AppNavigator.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 15.06.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit
import CoreData

class AppNavigator: NSObject {
    var window: UIWindow?
    var navController: MeNavigationController?
    
    var isAuthenticating = false
    
    
    init(_ window: UIWindow?) {
        self.window = window
        
        super.init()

        navController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navController?.navigationBar.shadowImage = UIImage()
        navController?.navigationBar.isTranslucent = true
        didCheckLogin()
        self.window?.makeKeyAndVisible()
    }
    
    private func didCheckLogin() {
        if existCurrentUser() {
            
            CurrentSession.shared.token = getCurrentUser().accessToken ?? ""
            
            if UserDefaults.standard.bool(forKey: UserDefaultsName.StartFromScanner){
                HomeTabViewController.shared.setTab(.qr)
            }
            HomeTabViewController.shared.setTab(.voucher)
            self.window?.rootViewController = TransactionManager.shared.tabBarControllerScreen()
        }else {
            navController = TransactionManager.shared.loginScreen()
            self.window?.rootViewController = navController
        }
    }
    
    func getCurrentUser() -> User{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "currentUser == YES")
        do {
            let results = try context.fetch(fetchRequest) as? [User]
            if results?.count != 0 {
                return results![0]
            }
        } catch {}
     return User()
    }
    
    func existCurrentUser() -> Bool{
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           let context = appDelegate.persistentContainer.viewContext
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
           fetchRequest.predicate = NSPredicate(format:"currentUser == YES")
           do{
               let results = try context.fetch(fetchRequest) as? [User]
               if results?.count != 0 {
                  
                   return true
               }
           } catch{}
           return false
       }
}
