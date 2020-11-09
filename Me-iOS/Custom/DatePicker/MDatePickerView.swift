//
//  MDatePickerView.swift
//  Me-iOS
//
//  Created by Development Kingdom on 18.09.2020
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

public class MDatePickerView : UIView {
    
    var Y = Calendar.current.component(.year, from: Date())
    var D = Calendar.current.component(.day, from: Date())
    var M = Calendar.current.component(.month, from: Date())
    
    public var delegate : MDatePickerViewDelegate?
    
    public var Color : UIColor = UIColor(red: 255/255, green: 97/255, blue: 82/255, alpha: 1)
    
    public var from : Int = 1980
    
    public var to : Int = Calendar.current.component(.year, from: Date())
    
    public var cornerRadius : CGFloat = 18 {
        didSet{
            Col.layer.cornerRadius = cornerRadius
        }
    }
    
    public var selectDate : Date? {
        didSet{
            if let select = selectDate{
                Y = Calendar.current.component(.year, from: select)
                D = Calendar.current.component(.day, from: select)
                M = Calendar.current.component(.month, from: select)
                
                let dateComponents = DateComponents(calendar: Calendar.current, year: Y, month: M, day: D)
                if let date = dateComponents.date {
                    delegate?.mdatePickerView(selectDate: date)
                }
                
                scrollToitem()
            }
        }
    }
    
    let ColYearCellID = "ColYearCellID"
    let ColMonthCellID = "ColMonthCellID"
    let ColDayCellID = "ColDayCellID"
    let ColOkID = "ColOkID"
    
    lazy var Col : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        col.layer.cornerRadius = cornerRadius
        col.layer.borderColor = UIColor.lightGray.cgColor
        col.layer.borderWidth = 0.7
        col.dataSource = self
        col.delegate = self
        if #available(iOS 11.0, *) {
            col.backgroundColor = UIColor(named: "DarkGray_DarkTheme")
        } else {
            col.backgroundColor = .white
        }
        col.translatesAutoresizingMaskIntoConstraints = false
        return col
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Col.register(ColYearCell.self, forCellWithReuseIdentifier: ColYearCellID)
        Col.register(ColMonthCell.self, forCellWithReuseIdentifier: ColMonthCellID)
        Col.register(ColDayCell.self, forCellWithReuseIdentifier: ColDayCellID)
        Col.register(CollOKCell.self, forCellWithReuseIdentifier: ColOkID)
        
        addSubview(Col)
        NSLayoutConstraint.activate([
                    Col.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                    Col.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
                    Col.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
                    Col.rightAnchor.constraint(equalTo: rightAnchor, constant: 0)
        ])
        
    }
    
    func scrollToitem() {
        if let YearCell = Col.cellForItem(at: [0,2]) as? ColYearCell{
            YearCell.Selected = [Y,M,D]
            YearCell.layoutSubviews()
        }
        if let MonthCell = Col.cellForItem(at: [0,0]) as? ColMonthCell{
            MonthCell.Selected = [Y,M,D]
            MonthCell.layoutSubviews()
        }
        if let DayCell = Col.cellForItem(at: [0,1]) as? ColDayCell{
            DayCell.Selected = [Y,M,D]
            DayCell.layoutSubviews()
        }
        Col.reloadData()
    }
    
    override public func layoutSubviews() {
        Col.collectionViewLayout.invalidateLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MDatePickerView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        
        switch indexPath.row {
        case 0:
           let cell = Col.dequeueReusableCell(withReuseIdentifier: ColMonthCellID, for: indexPath) as! ColMonthCell
            cell.Col.backgroundColor = Color
            cell.WeekColor = Color
            cell.Selected = [Y,M,D]
            cell.delegate = self
            return cell
        case 1:
            let cell = Col.dequeueReusableCell(withReuseIdentifier: ColDayCellID, for: indexPath) as! ColDayCell
            cell.WeekColor = Color
            cell.Selected = [Y,M,D]
            cell.delegate = self
            return cell
        case 2:
           let cell = Col.dequeueReusableCell(withReuseIdentifier: ColYearCellID, for: indexPath) as! ColYearCell
            cell.from = from
            cell.to = to
            cell.WeekColor = Color
            cell.Selected = [Y,M,D]
            cell.delegate = self
            return cell
        case 3:
            let cell = Col.dequeueReusableCell(withReuseIdentifier: ColOkID, for: indexPath) as! CollOKCell
            return cell
        default:
            return UICollectionViewCell()
        }
       
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellHeight = (Col.frame.height / 4) - 1
        
        if indexPath.row == 1{
            return CGSize(width: Col.frame.width, height: cellHeight * 1.6)
        }else if indexPath.row == 3 {
            return CGSize(width: Col.frame.width, height: cellHeight * 1)
        }
        
        return CGSize(width: Col.frame.width, height: cellHeight * 0.7)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            self.removeAnimate()
        }
    }
}

extension MDatePickerView : ColCellDelegate {
    
    func CallDate(Type:DateType) {
        switch Type {
        case .Day(week: let Week, range: _):
            D = Week
        case .Month(let month):
            M = month
        case .Year(select: let year, range: _):
            Y = year
        }
        
        let dateComponents = DateComponents(calendar: Calendar.current, year: Y, month: M, day: D)
        if let date = dateComponents.date {
            delegate?.mdatePickerView(selectDate: date)
        }
        
       scrollToitem()
    }
    
}
