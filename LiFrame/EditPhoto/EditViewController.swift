//
//  EditViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/14.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class EditViewController: UIViewController {
   
    // 亮度、對比、飽和度被包在 CIColorControls filter 中，所以我們建立 filter 時要指定是 CIColorControls
    let filter = CIFilter(name: "CIColorControls")
    // 要修的圖從前面傳過來的
    var editImage: UIImage?
    // 要修的圖
    let editImageView: UIImageView = {
    let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
}()
    // 調整亮度的 slider
    let editLightSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = -1
        slider.maximumValue = 1
        slider.value = 0
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(brightEdit), for: .valueChanged)
        return slider
    }()
    @objc func brightEdit() {
        let context = CIContext()
        // 要修的圖轉成CIImage
        guard let editImage = editImage else { return }
        let ciImage = CIImage(image: editImage) // editedImage是從主頁傳遞過來的照片
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(editLightSlider.value, forKey: kCIInputBrightnessKey)
        if let outputImage = filter?.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
        let newImage = UIImage(cgImage: cgImage)
        editImageView.image = newImage
        }
    }
    // TODO: 調整對比的 slider
    // 調整對比的 slider
    let editContrastSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0.25
        slider.maximumValue = 4
        slider.value = 1
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(contrastEdit), for: .valueChanged)
        return slider
    }()
    @objc func contrastEdit() {
        let context = CIContext()
        // 要修的圖轉成CIImage
        guard let editImage = editImage else { return }
        let ciImage = CIImage(image: editImage) // editedImage是從主頁傳遞過來的照片
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(editLightSlider.value, forKey: kCIInputContrastKey)
        if let outputImage = filter?.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
        let newImage = UIImage(cgImage: cgImage)
        editImageView.image = newImage
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(editImageView)
        view.addSubview(editLightSlider)
        view.addSubview(editContrastSlider)
        setAutoLayout()
    }
    func setAutoLayout() {
        editImageView.image = editImage
        editImageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            editImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            editImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            editLightSlider.topAnchor.constraint(equalTo: editImageView.bottomAnchor, constant: 50),
            editLightSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editLightSlider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            editContrastSlider.topAnchor.constraint(equalTo: editLightSlider.bottomAnchor, constant: 50),
            editContrastSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editContrastSlider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])

    }
}
