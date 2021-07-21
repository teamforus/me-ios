//
//  PullUpQRViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 10/25/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

public enum QRType{
    case Voucher
    case Record
    case Profile
}

class PullUpQRViewController: UIViewController {
    
    var timer : Timer! = Timer()
    var qrType: QRType
    var voucher: Voucher?
    var record: Record?
    
    lazy var bottomQRViewModel: CommonBottomViewModel! = {
        return CommonBottomViewModel()
    }()
    
    
    // MARK: - Properties
    private var bodyView: UIView = {
        let view = UIView(frame: .zero)
        view.colorName("DarkGray_DarkTheme")
        return view
    }()
    
    private var iconSmallQR: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = R.font.googleSansBold(size: 12)
        label.text = "QR-CODE"
        label.textColor = Color.blueText
        return label
    }()
    
    private var closeButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        return button
    }()
    
    private var qrImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = Image.qrImageSmall
        return imageView
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        return stackView
    }()
    
    private var voucherNameLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansRegular(size: 17)
        return label
    }()
    
    private var dateExpiredLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansRegular(size: 15)
        return label
    }()
    
    private var titleQRLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansBold(size: 20)
        return label
    }()
    
    private var descriptionLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansRegular(size: 15)
        return label
    }()
    
    
    // MARK: - Init
    init(voucher: Voucher? = nil, qrType: QRType, record: Record? = nil) {
        self.voucher = voucher
        self.qrType = qrType
        self.record = record
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomQRViewModel.vc = self
        bodyView.roundCorners(corners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 9)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.bodyView.snp.updateConstraints { make in
                make.height.equalTo(439)
                make.bottom.left.right.equalTo(self.view)
            }
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        setupAccessibility()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch qrType {
            
        case .Voucher:
            
            self.titleQRLabel.text = Localize.this_is_your_vouchers_qr_code()
            self.descriptionLabel.text = Localize.let_shopkeeper_scan_it_make_payment_from_your_voucher()
            
            self.qrImageView.generateQRCode(from: "{ \"type\": \"voucher\",\"value\": \"\(self.voucher?.address ?? String.empty)\", \"imgUrl\" : \"https://media.forus.io/assets/me-logo.png\" }")
            
            if voucher?.product != nil {
                voucherNameLabel.text = voucher?.product?.name ?? String.empty
            }else {
                voucherNameLabel.text = voucher?.fund?.name ?? String.empty
            }
            
            dateExpiredLabel.text = Localize.this_voucher_is_expired_on((voucher?.expire_at?.date?.dateFormaterExpireDate())!)
            
        case .Record:
            self.voucherNameLabel.isHidden = true
            self.dateExpiredLabel.isHidden = true
            self.titleQRLabel.text = Localize.this_is_your_vouchers_qr_code()
            if let name = self.record?.name {
                self.descriptionLabel.text = Localize.let_shopkeeper_scan_it_to_make_validtion_to_your_record(name)
            }
            
            bottomQRViewModel.completeRecord = { [weak self] (record) in
                
                DispatchQueue.main.async {
                    UserDefaults.standard.set(record.uuid ?? String.empty, forKey: UserDefaultsName.CurrentRecordUUID)
                    self?.qrImageView.generateQRCode(from: "{ \"type\": \"record\",\"value\": \"\(record.uuid ?? String.empty)\", \"imgUrl\" : \"https://media.forus.io/assets/me-logo.png\" }")
                }
            }
            
            bottomQRViewModel.initFetchRecordToken(idRecords: record?.id ?? 0)
            
            
        case .Profile:
            bottomQRViewModel.completeIdentity = { [weak self] (identityAddress) in
                
                DispatchQueue.main.async {
                    self?.qrImageView.generateQRCode(from: "{ \"type\": \"identity\",\"value\": \"\(identityAddress)\", \"imgUrl\" : \"https://media.forus.io/assets/me-logo.png\" }")
                }
            }
            bottomQRViewModel.getIndentity()
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    @IBAction func closeQR(_ sender: Any) {
        closeQRAction()
    }
    
    @IBAction func closeGesture(_ sender: Any) {
        closeQRAction()
    }
    
    func closeQRAction(){
        self.bodyView.snp.updateConstraints { make in
            make.height.equalTo(439)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(439)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (isFinished) in
            self.view.removeFromSuperview()
        })
    }
}

extension PullUpQRViewController {
    // MARK: - Add Subviews
    private func addSubviews() {
        self.view.addSubview(bodyView)
        let views = [iconSmallQR, titleLabel, closeButton, qrImageView, stackView]
        views.forEach { view in
            self.bodyView.addSubview(view)
        }
    }
}

extension PullUpQRViewController {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        
    }
}

// MARK: - Accessibility Protocol

extension PullUpQRViewController: AccessibilityProtocol {
    func setupAccessibility() {
        qrImageView.setupAccesibility(description: "QR Code", accessibilityTraits: .image)
        closeButton.setupAccesibility(description: "Close", accessibilityTraits: .button)
    }
}
