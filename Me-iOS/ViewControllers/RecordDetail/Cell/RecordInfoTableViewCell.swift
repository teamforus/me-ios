//
//  RecordInfoTableViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 15.07.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

class RecordInfoTableViewCell: UITableViewCell {
    
    let bodyView: CustomCornerUIView = {
        let view = CustomCornerUIView(frame: .zero)
        view.rounded(cornerRadius: 8)
        view.colorName = "Gray_Dark_DarkTheme"
        return view
    }()
    
    let typeRecord: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = R.font.googleSansRegular(size: 13)
        label.textColor = Color.lightGrayText
        return label
    }()
    
    let valueRecord: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansMedium(size: 18)
        return label
    }()
    
    let showQrButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.backgroundColor = Color.buttonRecordBg
        button.rounded(cornerRadius: 18)
        button.setTitleColor(Color.blueText, for: .normal)
        button.setTitle(Localize.show_qr_code(), for: .normal)
        button.titleLabel?.font = R.font.googleSansMedium(size: 13)
        return button
    }()

    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    func setup(_ record: Record) {
        self.typeRecord.text = record.name
        self.valueRecord.text = record.value
    }
}

extension RecordInfoTableViewCell {
    // MARK: - Add Subviews
    private func addSubviews() {
        self.contentView.addSubview(bodyView)
        let views = [typeRecord, valueRecord, showQrButton]
        views.forEach { view in
            bodyView.addSubview(view)
        }
    }
}

extension RecordInfoTableViewCell {
 // MARK: - Setup Constraints
    private func setupConstraints() {
        bodyView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(10)
            make.top.equalTo(contentView).offset(14)
            make.right.equalTo(contentView).offset(-10)
            make.bottom.equalTo(contentView).offset(-14)
        }
        
        typeRecord.snp.makeConstraints { make in
            make.top.left.equalTo(bodyView).offset(19)
        }
        
        valueRecord.snp.makeConstraints { make in
            make.top.equalTo(typeRecord.snp.bottom).offset(3)
            make.left.equalTo(bodyView).offset(19)
        }
        
        showQrButton.snp.makeConstraints { make in
            make.left.equalTo(bodyView).offset(15)
            make.right.equalTo(bodyView).offset(-15)
            make.height.equalTo(40)
            make.bottom.equalTo(bodyView).offset(-14)
        }
    }
}


