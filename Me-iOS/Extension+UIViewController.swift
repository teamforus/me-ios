//
//  Extensions.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController{
    
    @IBAction func back(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dismiss(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    func showToast(message : String, messageButton: String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 15, y: self.view.frame.size.height-100, width: self.view.frame.size.width - 30, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "GoogleSans-Regular", size: 11.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        let toastLabel2 = UILabel(frame: CGRect(x: 15, y: self.view.frame.size.height-50, width: self.view.frame.size.width - 30, height: 35))
        toastLabel2.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel2.textColor = UIColor.white
        toastLabel2.textAlignment = .center;
        toastLabel2.font = UIFont(name: "GoogleSans-Regular", size: 12.0)
        toastLabel2.minimumScaleFactor = 0.5
        toastLabel2.adjustsFontSizeToFitWidth = true
        toastLabel2.text = messageButton
        toastLabel2.alpha = 1.0
        toastLabel2.layer.cornerRadius = 10;
        toastLabel2.clipsToBounds  =  true
        
        let toastButton = UIButton(frame: CGRect(x: 15, y: self.view.frame.size.height-50, width: self.view.frame.size.width - 30, height: 35))
        toastButton.backgroundColor = .clear
        toastButton.addTarget(self, action: #selector(self.goToSettings(sender:)), for: .touchUpInside)
        
        self.view.addSubview(toastLabel)
        self.view.addSubview(toastButton)
        self.view.addSubview(toastLabel2)
        UIView.animate(withDuration: 5.0, delay: 1.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
            toastLabel2.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
            toastLabel2.removeFromSuperview()
            toastButton.removeFromSuperview()
        })
    }
    
    func showSimpleToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 15, y: self.view.frame.size.height-100, width: self.view.frame.size.width - 30, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "GoogleSans-Regular", size: 11.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.9, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    @objc func goToSettings( sender :UIButton){
        ScanPermission.goToSystemSetting()
    }
    
    func showSimpleAlert(title:String, message: String){
        
        let allertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        allertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
        }))
        
        self.present(allertController, animated: true)
    }
    
    func showSimpleAlertWithAction(title:String, message: String, okAction: UIAlertAction, cancelAction: UIAlertAction){
        
        let allertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        allertController.addAction(okAction)
        
        allertController.addAction(cancelAction)
        
        self.present(allertController, animated: true)
        
    }
    
    func showSimpleAlertWithSingleAction(title:String, message: String, okAction: UIAlertAction) {
        
        let allertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        allertController.addAction(okAction)
        
        
        self.present(allertController, animated: true)
    
        
    }
    
    func validateEmail(_ candidate: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    
    func getLanguageISO() -> String {
        return Locale.current.languageCode!
    }
}


