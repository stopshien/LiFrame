//
//  UIButtonExt.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/10/18.
//

import UIKit

class CustomButton: UIButton {
    var hitEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let hitFrame = bounds.inset(by: hitEdgeInsets)
        return hitFrame.contains(point)
    }
}
