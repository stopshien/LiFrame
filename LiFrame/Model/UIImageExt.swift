//
//  UIImageExt.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/17.
//

import Foundation
import UIKit
extension UIImage {
    func toCGImagePropertyOrientation() -> CGImagePropertyOrientation? {
        switch self.imageOrientation {
        case .up: return .up
        case .upMirrored: return .upMirrored
        case .down: return .down
        case .downMirrored: return .downMirrored
        case .leftMirrored: return .leftMirrored
        case .right: return .right
        case .rightMirrored: return .rightMirrored
        case .left: return .left
        @unknown default: return nil
        }
    }
}
