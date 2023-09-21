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
    func rotateImage(_ image: UIImage, withOrientation orientation: UIImage.Orientation) -> UIImage {
        guard let cgImage = image.cgImage else {
            return image
        }
        
        let rotatedImage: UIImage
        
        switch orientation {
        case .up:
            rotatedImage = image
        case .upMirrored:
            rotatedImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: .upMirrored)
        case .down:
            rotatedImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: .down)
        case .downMirrored:
            rotatedImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: .downMirrored)
        case .left:
            rotatedImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: .left)
        case .leftMirrored:
            rotatedImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: .leftMirrored)
        case .right:
            rotatedImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: .right)
        case .rightMirrored:
            rotatedImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: .rightMirrored)
        @unknown default:
            rotatedImage = image
        }
        return rotatedImage
    }
    func rotateToCorrectOrientation(_ orientation: UIImage.Orientation) -> UIImage {
            // 根據方向調整照片
            switch orientation {
            case .up:
                return self
            case .down:
                return self.rotated(by: .pi)
            case .left:
                return self.rotated(by: .pi/2)
            case .right:
                return self.rotated(by: -.pi/2)
            default:
                return self
            }
        }
        
        func rotated(by radians: CGFloat) -> UIImage {
            guard let cgImage = self.cgImage else {
                return self
            }
            let rotatedSize = CGSize(width: self.size.height, height: self.size.width)
            let rotatedRect = CGRect(origin: .zero, size: rotatedSize)
            
            UIGraphicsBeginImageContext(rotatedSize)
            let context = UIGraphicsGetCurrentContext()!
            
            context.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
            context.rotate(by: radians)
            context.scaleBy(x: 1.0, y: -1.0)
            
            context.draw(cgImage, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
            
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
}
