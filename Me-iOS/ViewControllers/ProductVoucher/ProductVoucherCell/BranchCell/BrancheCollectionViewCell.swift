//
//  BrancheCollectionViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 28.04.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit
import MapKit

class BrancheCollectionViewCell: UICollectionViewCell {
    static let identifier = "BrancheCollectionViewCell"
    var parentViewController: UIViewController?
    var address: String?
    var latitude: Double!
    var longitude: Double!
    
    // MARK: - Properties
    
    let bodyView: Background_DarkMode = {
        let view = Background_DarkMode(frame: .zero)
        view.rounded(cornerRadius: 9)
        view.colorName = "GrayWithLight_Dark_DarkTheme"
        return view
    }()
    
    let iconLocation: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = R.image.location_icon()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let locationNameLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansRegular(size: 15)
        label.text = "Middenweg 212, 1701GH, Heerhugowaard"
        label.numberOfLines = 2
        return label
    }()
    
    let showMapButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.setTitle("Show Map", for: .normal)
        button.titleLabel?.font = R.font.googleSansRegular(size: 12)
        button.setTitleColor(#colorLiteral(red: 0.1903552711, green: 0.369412154, blue: 0.9929068685, alpha: 1), for: .normal)
        return button
    }()
    
    let iconPhone: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = R.image.phone_icon()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let phoneNumberLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.text = "0615 261 612"
        label.font = R.font.googleSansRegular(size: 15)
        return label
    }()
    
//    let iconClock: UIImageView = {
//        let imageView = UIImageView(frame: .zero)
//        imageView.image = R.image.clock_icon()
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
//
//    let scheduleOfficeLabel: UILabel_DarkMode = {
//        let label = UILabel_DarkMode(frame: .zero)
//        label.font = R.font.googleSansRegular(size: 15)
//        label.numberOfLines = 2
//        label.text = "Mandaag – Vrijdag: 08:00 – 16 uur Zaterdag: 12:00 – 20:59"
//        return label
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        addSubviews()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup(office: Office) {
        locationNameLabel.text = office.address
        phoneNumberLabel.text = office.phone
        if let latitudeValue = office.lat, let lat = Double(latitudeValue) {
            self.latitude = lat
        }
        
        if let longitudeValue = office.lon, let lon = Double(longitudeValue) {
            self.longitude = lon
        }
    }
}

extension BrancheCollectionViewCell {
    // MARK: - Add Subviews
    private func addSubviews() {
        let views = [bodyView, iconLocation, locationNameLabel, showMapButton, iconPhone, phoneNumberLabel]
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(view)
        }
    }
}

extension BrancheCollectionViewCell {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            bodyView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            bodyView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            bodyView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconLocation.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            iconLocation.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            locationNameLabel.centerYAnchor.constraint(equalTo: iconLocation.centerYAnchor),
            locationNameLabel.leadingAnchor.constraint(equalTo: iconLocation.trailingAnchor, constant: 15)
        ])
        
        NSLayoutConstraint.activate([
            showMapButton.centerYAnchor.constraint(equalTo: iconLocation.centerYAnchor),
            showMapButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            showMapButton.leadingAnchor.constraint(equalTo: locationNameLabel.trailingAnchor, constant: 8),
            showMapButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            iconPhone.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            iconPhone.topAnchor.constraint(equalTo: self.iconLocation.bottomAnchor, constant: 36)
        ])
        
        NSLayoutConstraint.activate([
            phoneNumberLabel.centerYAnchor.constraint(equalTo: iconPhone.centerYAnchor),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: iconPhone.trailingAnchor, constant: 15)
        ])
        
//        NSLayoutConstraint.activate([
//            iconClock.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
//            iconClock.topAnchor.constraint(equalTo: self.iconPhone.bottomAnchor, constant: 36),
//            iconClock.widthAnchor.constraint(equalToConstant: 16),
//            iconLocation.heightAnchor.constraint(equalToConstant: 16)
//        ])
//
//        NSLayoutConstraint.activate([
//            scheduleOfficeLabel.centerYAnchor.constraint(equalTo: iconClock.centerYAnchor),
//            scheduleOfficeLabel.leadingAnchor.constraint(equalTo: iconClock.trailingAnchor, constant: 15),
//            scheduleOfficeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8)
//        ])
    }
}

extension BrancheCollectionViewCell {
    // MARK: - Setup Actions
    private func setupActions() {
        showMapButton.actionHandleBlock = { [weak self] (_) in
            DispatchQueue.main.async {
                self?.openOptionsMap()
            }
        }
    }
    
    private func openOptionsMap(){
        let actionSheet = UIAlertController.init(title: Localize.address(), message: nil, preferredStyle: .actionSheet)
        
        //open apple maps
        actionSheet.addAction(UIAlertAction.init(title: "Open in Apple Maps", style: UIAlertAction.Style.default, handler: { (action) in
            
            self.openMapForPlace(lattitude: self.latitude ?? 0.0, longitude: self.longitude ?? 0.0)
        }))
        
        //open google maps
        actionSheet.addAction(UIAlertAction.init(title: "Open in Google Maps", style: UIAlertAction.Style.default, handler: { (action) in
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
            {
                UIApplication.shared.open(URL(string:
                                                "comgooglemaps://?q=\(self.latitude ?? 0.0),\(self.longitude ?? 0.0)")!, options: [:], completionHandler: { (succes) in
                                                })
            } else if (UIApplication.shared.canOpenURL(URL(string:"https://maps.google.com")!))
            {
                UIApplication.shared.open(URL(string:
                                                "https://maps.google.com/?q=\(self.latitude ?? 0.0),\(self.longitude ?? 0.0)")!, options: [:], completionHandler: { (succes) in
                                                })
            }
        }))
        
        //copy to clipboard
        actionSheet.addAction(UIAlertAction.init(title: Localize.copy_address(), style: UIAlertAction.Style.default, handler: { (action) in
            UIPasteboard.general.string = self.address
            self.parentViewController?.showSimpleToast(message: Localize.copied_to_clipboard())
        }))
        actionSheet.addAction(UIAlertAction.init(title: Localize.cancel(), style: UIAlertAction.Style.cancel, handler: { (action) in
        }))
        //Present the controller
        actionSheet.popoverPresentationController?.sourceView = self
        actionSheet.popoverPresentationController?.sourceRect = self.frame
        parentViewController?.present(actionSheet, animated: true)
    }
    
    func openMapForPlace(lattitude: Double, longitude: Double) {
        
        let latitude: CLLocationDegrees = lattitude
        let longitude: CLLocationDegrees = longitude
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Address Name"
        mapItem.openInMaps(launchOptions: options)
    }
}
