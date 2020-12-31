//
//  String+Substring.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/26/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import UIKit

var Localize: R.string.localizable.Type {
    return R.string.localizable.self
}

extension String {
    
    func substringLeftPart() -> String{
        let number = self
        let parts = number.components(separatedBy: ".")
        let leftPart = parts[0]
        return leftPart
    }
    
    func substringRightPart() -> String{
        let number = self
        let parts = number.components(separatedBy: ".")
        let rightPart = parts[1]
        return rightPart
    }
    
    
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
    
    func customText(fontBigSize: CGFloat, minFontSize: CGFloat) -> NSMutableAttributedString {
        let fontSuper:UIFont? = UIFont(name: "GoogleSans-Medium", size: minFontSize)
        let font = UIFont(name: "GoogleSans-Medium", size: fontBigSize)
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font:font!])
        var indexA = Array(repeating: 0, count: 10)
        var indexB = Array(repeating: 0, count: 10)
        var indexC = Array(repeating: 0, count: 10)
        var indexD = Array(repeating: 0, count: 10)
        var x = 0
        var z = 0
        var y = 0
        var w = 0
        
        for a in 0..<self.count{
            let index = self.index(self.startIndex, offsetBy: a)
            if self[index] == "{"{
                indexA[x] = a
                //                debugPrint(indexA[x])
                x+=1
            }
            if self[index] == "}"{
                indexB[z] = a
                //                debugPrint(indexB[z])
                z+=1
            }
            if self[index] == "£"{
                indexC[y] = a
                y+=1
            }
            if self[index] == "$"{
                indexD[w] = a
                w+=1
            }
        }
        
        
        
        for  a in 0..<10{
            if indexA[a] != 0 || indexB[a] != 0 {
                for b in indexA[a]+1..<indexB[a]{
                    attString.setAttributes([NSAttributedString.Key.font:fontSuper!,NSAttributedString.Key.baselineOffset:10], range: NSRange(location:b,length:1))
                }
            }
            if indexC[a] != 0 || indexD[a] != 0 {
                for b in indexC[a]+1..<indexD[a]{
                    attString.setAttributes([NSAttributedString.Key.font:fontSuper!,NSAttributedString.Key.baselineOffset:-5], range: NSRange(location:b,length:1))
                }
            }
        }
        attString.mutableString.replaceOccurrences(of: "{", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: attString.length))
        attString.mutableString.replaceOccurrences(of: "}", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: attString.length))
        attString.mutableString.replaceOccurrences(of: "£", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: attString.length))
        attString.mutableString.replaceOccurrences(of: "$", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: attString.length))
        return attString
    }
}
extension Substring {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
    
    
}

extension StringProtocol {
    var double: Double? { Double(self) }
    var float: Float? { Float(self) }
    var integer: Int? { Int(self) }
}

extension String {
    
    func showDeciaml() -> String {
        if self.double?.truncatingRemainder(dividingBy: 1) == 0.0 {
            return String(format: "%.0f,-", self.double!)
        }else  {
            return String(format: "%.2f", self.double!)
        }
    }
}
