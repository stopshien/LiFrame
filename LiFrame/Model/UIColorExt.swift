//
//  UIColorExt.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/20.
//

import Foundation
import UIKit
extension UIColor {
    static let mainColor = UIColor.init(hexString: "#554236")
    static let secondColor = UIColor.init(hexString: "#D7C4BB")
    static let PointColor = UIColor.init(hexString: "#554236")

    convenience init(hexString: String) {
        var hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
