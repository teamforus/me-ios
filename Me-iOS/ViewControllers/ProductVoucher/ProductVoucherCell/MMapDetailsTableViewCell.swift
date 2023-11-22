//
//  MMapDetailsTableViewCell.swift
//  Me-iOS
//
//  Created by mac on 02.02.2021.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit
import MapKit

class MMapDetailsTableViewCell: UITableViewCell {
    static let identifier = "MMapDetailsTableViewCell"
    var voucher: Voucher!
    var latitude: Double!
    var longitude: Double!
    var parentViewController: UIViewController?
    
    private let bodyView: Background_DarkMode = {
        let bodyView = Background_DarkMode(frame: .zero)
        bodyView.colorName = "Gray_Dark_DarkTheme"
        bodyView.roundCorners(corners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 16)
        return bodyView
    }()
    
    private let titleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansMedium(size: 21)
        return label
    }()
    
    private let subTitleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansRegular(size: 14)
        label.textColor = #colorLiteral(red: 0.556738019, green: 0.5565260053, blue: 0.577188611, alpha: 1)
        return label
    }()
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "iconVoucher")
        imageView.contentMode = .scaleAspectFit
        imageView.rounded(cornerRadius: 9)
        return imageView
    }()
    
    private let mapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.rounded(cornerRadius: 9)
        return mapView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
        mapView.delegate = self
        mapView.isUserInteractionEnabled = true
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
    
    func setupVoucher(voucher: Voucher?) {
        self.titleLabel.text = voucher?.fund?.organization?.name ?? ""
        self.subTitleLabel.text = voucher?.product?.organization?.name ?? ""
        self.iconImage.loadImageUsingUrlString(urlString: voucher?.product?.organization?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
        if let latitudeValue = voucher?.offices?.first?.lat, let lat = Double(latitudeValue) {
            self.latitude = lat
        }
        
        if let longitudeValue = voucher?.offices?.first?.lon, let lon = Double(longitudeValue) {
            self.longitude = lon
        }
        self.mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToMap)))
        let viewRegion = MKCoordinateRegion( center: CLLocationCoordinate2D(latitude: self.latitude ?? 0.0 , longitude: self.longitude ?? 0.0), latitudinalMeters: 10000, longitudinalMeters: 10000)
        self.mapView.setRegion(viewRegion, animated: false)
        self.mapView.region = viewRegion
        
        voucher?.offices?.forEach({ (office) in
            
            self.mapView.addAnnotation((self.setAnnotation(lattitude: self.latitude ?? 0.0, longitude: self.longitude ?? 0.0)))
        })
        
    }
    
    func showSimpleToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 15, y: self.contentView.frame.size.height-100, width: self.contentView.frame.size.width - 30, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "GoogleSans-Regular", size: 11.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        
        self.contentView.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.9, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension MMapDetailsTableViewCell {
    func addSubviews() {
        let views = [bodyView, titleLabel, subTitleLabel, iconImage, mapView]
        views.forEach { (view) in
            self.contentView.addSubview(view)
        }
    }
    
    func setupConstraints(){
        
        bodyView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView).offset(40)
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.bottom.equalTo(self.contentView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyView).offset(25)
            make.left.equalTo(bodyView).offset(67)
            make.right.equalTo(bodyView).offset(-10)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyView).offset(52)
            make.left.equalTo(bodyView).offset(67)
            make.right.equalTo(bodyView).offset(-10)
        }
       
        iconImage.snp.makeConstraints { make in
            make.top.equalTo(bodyView).offset(22)
            make.left.equalTo(bodyView).offset(10)
            make.height.width.equalTo(44)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(bodyView).offset(84)
            make.left.equalTo(bodyView).offset(10)
            make.right.equalTo(bodyView).offset(-10)
            make.bottom.equalTo(bodyView)
        }
    }
}


extension MMapDetailsTableViewCell {
    
    @objc func goToMap(){
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
            UIPasteboard.general.string = self.voucher.offices?.first?.address
            self.showSimpleToast(message: Localize.copied_to_clipboard())
        }))
        actionSheet.addAction(UIAlertAction.init(title: Localize.cancel(), style: UIAlertAction.Style.cancel, handler: { (action) in
        }))
        //Present the controller
        actionSheet.popoverPresentationController?.sourceView = mapView
        actionSheet.popoverPresentationController?.sourceRect = mapView.frame
        parentViewController?.present(actionSheet, animated: true)
    }
    
    func setAnnotation(lattitude: Double, longitude: Double) -> CustomPointAnnotation{
        let annotation = CustomPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(lattitude, longitude)
        annotation.imageName = "carLocation"
        return annotation
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

extension MMapDetailsTableViewCell: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        let reuseId = "annotation"
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.canShowCallout = true
        }
        else {
            anView?.annotation = annotation
        }
        let cpa = annotation as! CustomPointAnnotation
        anView?.image = UIImage(named:cpa.imageName)
        
        return anView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circle = MKCircleRenderer(overlay: overlay)
        circle.strokeColor = #colorLiteral(red: 0.3073092699, green: 0.4766488671, blue: 0.9586974978, alpha: 1)
        circle.fillColor = #colorLiteral(red: 0.746714294, green: 0.8004079461, blue: 0.9871394038, alpha: 0.7)
        circle.lineWidth = 1
        return circle
    }
}
