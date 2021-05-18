//
//  AppVersionUpdateNotifier.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 01.06.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit
import StoreKit

class AppVersionUpdateNotifier {
      static let KEY_APP_VERSION = "key_app_version"
      static let shared = AppVersionUpdateNotifier()
    var viewIsShoun: Bool = false
    var vc: UIViewController!
    var bottonLayoutConstraint: NSLayoutConstraint!
    
    private let bodyView: Background_DarkMode = {
        let view = Background_DarkMode(frame: .zero)
        view.colorName = "DarkGray_DarkTheme"
        view.roundCorners(corners: [.layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner], radius: 12)
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.masksToBounds = false
        return view
    }()
    
    private var logoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = #imageLiteral(resourceName: "logo_icon")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var updateButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("UPDATE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius =  8
        button.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        return button
    }()
    
    private var closeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(Localize.close().uppercased(), for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1), for: .normal)
        return button
    }()
    
    private lazy var messageLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Regular", size: 15)
        label.text = Localize.update_is_available()
        label.numberOfLines = 0
        return label
    }()

      private let userDefault:UserDefaults
      private var delegate:AppUpdateNotifier?

       init() {
          self.userDefault = UserDefaults.standard
        
      }

      func initNotifier(_ delegate:AppUpdateNotifier) {
          self.delegate = delegate
        isUpdateAvailable()
      }

      func isUpdateAvailable() {
          guard let info = Bundle.main.infoDictionary,
              let currentVersion = info["CFBundleShortVersionString"] as? String,
            let _ = info["CFBundleIdentifier"] as? String,
              let url = URL(string: "https://itunes.apple.com/lookup?bundleId=io.forus.me") else {
                  return
          }
        do {
          let data = try Data(contentsOf: url)
          guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
               return
          }
          if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
            if let versionBundle = Int(version.replacingOccurrences(of: ".", with: "")), let currentBundle =  Int(currentVersion.replacingOccurrences(of: ".", with: "")) {
                delegate?.hasNewVersion(shouldBeUpdated: currentBundle < versionBundle)
            }
    
          }
        }catch { }
      }
  }

  protocol AppUpdateNotifier {
    func hasNewVersion(shouldBeUpdated: Bool)
  }
  extension Bundle {
      var shortVersion: String {
          return infoDictionary!["CFBundleShortVersionString"] as! String
      }
      var buildVersion: String {
          return infoDictionary!["CFBundleVersion"] as! String
      }
  }

// MARK: - Setup Views

extension AppVersionUpdateNotifier {
    
    func showUpdateView() -> UIView {
        return bodyView
    }
    
    func setupView(){
        setupViewForConstraints()
        setupConstraints()
        updateButton.addTarget(vc, action: #selector(vc.updateApp), for: .touchUpInside)
        closeButton.addTarget(vc, action: #selector(vc.closeUpdateNotifier), for: .touchUpInside)
        viewIsShoun = true
        self.bodyView.showAnimate()
    }
    
    func setupViewForConstraints() {
        let views = [bodyView, logoImageView, updateButton, messageLabel, closeButton]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        bodyView.addSubview(logoImageView)
        bodyView.addSubview(updateButton)
        bodyView.addSubview(messageLabel)
        bodyView.addSubview(closeButton)
    }
    
    func setupConstraints() {
        
        bodyView.snp.makeConstraints { make in
            make.left.equalTo(vc.view).offset(16)
            make.right.equalTo(vc.view).offset(-16)
            make.bottom.equalTo(vc.view).offset(-50)
            make.height.equalTo(100)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.left.equalTo(bodyView).offset(16)
            make.centerY.equalTo(bodyView)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bodyView).offset(-20)
            make.left.equalTo(logoImageView.snp.right).offset(20)
            make.right.equalTo(bodyView).offset(-10)
        }
        
        closeButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.bottom.equalTo(bodyView).offset(-10)
            make.left.equalTo(logoImageView.snp.right).offset(20)
        }
        
        updateButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.bottom.equalTo(bodyView).offset(-10)
            make.left.equalTo(closeButton.snp.right).offset(20)
        }
    }
}

extension AppVersionUpdateNotifier {
    func closeBodyView() {
        viewIsShoun = false
        Preference.userHasCloseUpdateNotifier = true
        self.bodyView.removeAnimate()
    }
}
