//
//  ScanPermission.swift
//  HSScanCode
//
//  Created by Hanson on 2018/1/31.
//

import Foundation
import AssetsLibrary
import Photos

struct ScanPermission {
    
    static func authorizePhoto(comletion: @escaping (Bool) -> Void) {
        let grantedStatus = PHPhotoLibrary.authorizationStatus()
        switch grantedStatus {
        case .authorized:
            comletion(true)
        case .denied, .restricted:
            comletion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    comletion(status == .authorized ? true : false)
                }
            })
        }
    }
    
    static func authorizeCamera(comletion: @escaping (Bool) -> Void) {
        let grantedStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch grantedStatus {
        case .authorized:
            comletion(true)
        case .denied, .restricted:
            comletion(false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (status) in
                DispatchQueue.main.async {
                    comletion(status)
                }
            })
        }
    }
    
    static func goToSystemSetting() {
        if let appSetting = URL(string: UIApplicationOpenSettingsURLString) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appSetting)
            }
        }
    }
}
