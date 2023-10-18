//
//  UIView+Extension.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/28.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

extension UIView {
    // 添加陰影效果
    func addShadow(color: UIColor = .lutCollectionViewColor, opacity: Float = 0.5, offset: CGSize = .zero, radius: CGFloat = 5) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
    func addFadingCircles(view: UIView) {
        let circleColors: [UIColor] = [.PointColor, .mainColor, .PointColor, .mainLabelColor, .mainLabelColor]
           let circleSizes: [CGFloat] = [40.0, 200, 100, 80, 300]
           for (index, color) in circleColors.enumerated() {
               let circleView = UIView()
               let circleSize = circleSizes[index]

               circleView.frame = CGRect(x: CGFloat(Int.random(in: 0...300)),
                                         y: CGFloat(Int.random(in: 0...800)),
                                         width: circleSize, height: circleSize)

               circleView.backgroundColor = color
               circleView.layer.cornerRadius = circleSize / 2
               circleView.alpha = 0.0 // 設置初始透明度為 0

               view.addSubview(circleView)

               UIView.animate(withDuration: 1.0, delay: Double(index) * 0.5, animations: {
                   circleView.alpha = 0.6 // 將透明度漸變為 0.6
               })
           }
       }
//    // Border Color
//    @IBInspectable var lkBorderColor: UIColor? {
//        get {
//            guard let borderColor = layer.borderColor else {
//                return nil
//            }
//            return UIColor(cgColor: borderColor)
//        }
//        set {
//            layer.borderColor = newValue?.cgColor
//        }
//    }
//
//    // Border width
//    @IBInspectable var lkBorderWidth: CGFloat {
//        get {
//            return layer.borderWidth
//        }
//        set {
//            layer.borderWidth = newValue
//        }
//    }
//
//    // Corner radius
//    @IBInspectable var lkCornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//        }
//    }
//
//    func stickSubView(_ objectView: UIView) {
//        objectView.removeFromSuperview()
//        addSubview(objectView)
//        objectView.translatesAutoresizingMaskIntoConstraints = false
//        objectView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        objectView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        objectView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        objectView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//    }
//
//    func stickSubView(_ objectView: UIView, inset: UIEdgeInsets) {
//        objectView.removeFromSuperview()
//        addSubview(objectView)
//        objectView.translatesAutoresizingMaskIntoConstraints = false
//        objectView.topAnchor.constraint(equalTo: topAnchor, constant: inset.top).isActive = true
//        objectView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset.left).isActive = true
//        objectView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset.right).isActive = true
//        objectView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset.bottom).isActive = true
//    }
}
