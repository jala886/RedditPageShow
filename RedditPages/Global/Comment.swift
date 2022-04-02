//
//  Comment.swift
//  RedditPages
//
//  Created by jianli on 4/1/22.
//

import Foundation
import UIKit


let tableViewCellTitleHeight = 55.0
let tableViewCellImageHeight = 200.0
let tableViewCellBottomHeight = 60.0
let titleFont = UIFont.boldSystemFont(ofSize: 15)

extension Double {
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal
    }
}

func formatNumber(_ n: Int) -> String {
    let num = abs(Double(n))
    let sign = (n < 0) ? "-" : ""

    switch num {
    case 1_000_000_000...:
        var formatted = num / 1_000_000_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(formatted)B"

    case 1_000_000...:
        var formatted = num / 1_000_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(formatted)M"

    case 1_000...:
        var formatted = num / 1_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(formatted)K"

    case 0...:
        return "\(n)"

    default:
        return "\(sign)\(n)"
    }
}

extension String {
    // MARK:- 获取字符串的CGSize
    func getSize(with font: UIFont) -> CGSize {
        return getSize(width: UIScreen.main.bounds.width, font: font)
    }
    // MARK:- 获取字符串的CGSize(指定宽度)
    func getSize(width: CGFloat, font: UIFont) -> CGSize {
        let str = self as NSString
         
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        return str.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
    }
}
/*
extension String {
func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
    let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.text = self
    label.font = font
    label.sizeToFit()

    return label.frame.height
 }
}
  */

