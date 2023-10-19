//
//  UISliderExt.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/10/19.
//

import UIKit
extension UISlider {
    static func customSlider(minimumValue: Float, maximumValue: Float, startVlaue: Float) -> UISlider {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.isContinuous = true
        slider.minimumTrackTintColor = .mainLabelColor
        slider.minimumValue = minimumValue
        slider.maximumValue = maximumValue
        slider.value = startVlaue
        return slider
    }
}
