//
//  Manager.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/15.
//

import Foundation
import PhotosUI
import FirebaseFirestore
class Manager {
    static let shared = Manager()
    let db = Firestore.firestore()
    private init() {}
    // 讀取 Lut 對象
    func loadLuts() -> [Lut]? {
        let userDefaults = UserDefaults.standard
        if let savedLuts = userDefaults.array(forKey: "luts") as? [[String: Any]] {
            // compactMap 不處理 nil 值得 map
            return savedLuts.compactMap { lutData in
                guard let name = lutData["name"] as? String,
                      let brightness = lutData["brightness"] as? Float,
                      let contrast = lutData["contrast"] as? Float else {
                    return nil
                }
                return Lut(name: name, bright: brightness, contrast: contrast)
            }
        }
        return []
    }
    // 修圖
    func applyBrightnessAndContrast(_ image: UIImage, brightness: Float, contrast: Float) -> UIImage? {
        let filter = CIFilter(name: "CIColorControls")
//        let ciImage = CIImage(image: image)
        // 需要處理轉向設定
        var ciImage = CIImage(image: image)
            if let orientation = image.toCGImagePropertyOrientation() {
                ciImage = CIImage(image: image, options: [CIImageOption.applyOrientationProperty: true])
                ciImage = ciImage?.oriented(orientation)
            } else {
                ciImage = CIImage(image: image)
            }
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(brightness, forKey: kCIInputBrightnessKey)
        filter?.setValue(contrast, forKey: kCIInputContrastKey)

        if let outputImage = filter?.outputImage {
            let context = CIContext()
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
    // 儲存相片至相簿
    func saveImagesToPhotoLibrary(_ images: [UIImage]) {
        PHPhotoLibrary.shared().performChanges {
            for image in images {
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                request.creationDate = Date()
            }
        } completionHandler: { (success, error) in
            if success {
                print("相片已儲存至相簿")
            } else if let error = error {
                print("儲存相片至相簿時發生錯誤：\(error.localizedDescription)")
            }
        }
    }
}
