//
//  MBranchesTableViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 02.02.2021.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MBranchesTableViewCell: UITableViewCell {
  static let identifier = "MBranchesTableViewCell"
    var offices: [Office] = []
    
    private var countBranchesLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = R.font.googleSansRegular(size: 17)
        return label
    }()
    
    private var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubiews()
        setupConstraints()
        setupCollectionView()
        self.selectionStyle = .none
        if #available(iOS 11.0, *) {
            self.backgroundColor = UIColor(named: "DarkGray_DarkTheme")
        } else {}
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BrancheCollectionViewCell.self, forCellWithReuseIdentifier: BrancheCollectionViewCell.identifier)
    }
    
    func setup(voucher: Voucher?) {
        guard let offices = voucher?.offices else {
            return
        }
        self.countBranchesLabel.text = "\(offices.count) Branches"
        self.offices = offices
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDelegate
extension MBranchesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return offices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrancheCollectionViewCell.identifier, for: indexPath) as? BrancheCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setup(office: offices[indexPath.row])
        return cell
    }
}

extension MBranchesTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 330, height: 121)
    }
}

extension MBranchesTableViewCell {
    // MARK: - Add Subviews
    private func addSubiews() {
        let views = [countBranchesLabel, collectionView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(view)
        }
    }
}

extension MBranchesTableViewCell {
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            countBranchesLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 17),
            countBranchesLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.countBranchesLabel.bottomAnchor, constant: 6),
            collectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        ])
    }
}
