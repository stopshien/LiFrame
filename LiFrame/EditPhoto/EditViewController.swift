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
    // 如果是直接給予 userDefault，在 nil 的時候無法進行 append
    var luts = [Lut]()
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
        return slider
    }()
    // 調整對比的 slider
    let editContrastSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0.25
        slider.maximumValue = 4
        slider.value = 1
        slider.isContinuous = true
        return slider
    }()
    let lutSaveButton: UIButton = {
       let button = UIButton()
        button.setTitle("儲存風格檔", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "相機"
        view.backgroundColor = .white
        view.addSubview(editImageView)
        view.addSubview(editLightSlider)
        view.addSubview(editContrastSlider)
        view.addSubview(lutSaveButton)
        setAutoLayout()
        setTarget()
        if let luts = LutManager.shared.loadLuts() {
            self.luts = luts
        } else {
            luts = []
        }
    }
    func setTarget() {
        editLightSlider.addTarget(self, action: #selector(brightEdit), for: .valueChanged)
        editContrastSlider.addTarget(self, action: #selector(contrastEdit), for: .valueChanged)
        lutSaveButton.addTarget(self, action: #selector(saveLut), for: .touchUpInside)
    }
    func setAutoLayout() {
        editImageView.image = editImage
        editImageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            editImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            editImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editImageView.heightAnchor.constraint(equalTo: editImageView.widthAnchor, multiplier: 4/3),
            editImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            editLightSlider.topAnchor.constraint(equalTo: editImageView.bottomAnchor, constant: 50),
            editLightSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editLightSlider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            editContrastSlider.topAnchor.constraint(equalTo: editLightSlider.bottomAnchor, constant: 50),
            editContrastSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editContrastSlider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            lutSaveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            lutSaveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50)
        ])
    }
    @objc func brightEdit() {
        let context = CIContext()
        guard let editImage = editImage else { return }
        // 要修的圖轉成CIImage
        // 需要處理轉向設定
        var ciImage = CIImage(image: editImage)
            if let orientation = editImage.toCGImagePropertyOrientation() {
                ciImage = CIImage(image: editImage, options: [CIImageOption.applyOrientationProperty: true])
                ciImage = ciImage?.oriented(orientation)
            } else {
                ciImage = CIImage(image: editImage)
            }
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(editLightSlider.value, forKey: kCIInputBrightnessKey)
        if let outputImage = filter?.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
        let newImage = UIImage(cgImage: cgImage)
        editImageView.image = newImage
        }
    }
    @objc func contrastEdit() {
        let context = CIContext()
        guard let editImage = editImage else { return }
        // 要修的圖轉成CIImage
        // 需要處理轉向設定
        var ciImage = CIImage(image: editImage)
            if let orientation = editImage.toCGImagePropertyOrientation() {
                ciImage = CIImage(image: editImage, options: [CIImageOption.applyOrientationProperty: true])
                ciImage = ciImage?.oriented(orientation)
            } else {
                ciImage = CIImage(image: editImage)
            }
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(editContrastSlider.value, forKey: kCIInputContrastKey)
        if let outputImage = filter?.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
        let newImage = UIImage(cgImage: cgImage)
        editImageView.image = newImage
        }
    }
    @objc func saveLut() {
        showAlert()
    }
    func showAlert() {
        // 建立一個提示框
         let alertController = UIAlertController(
             title: "新增風格檔",
             message: "請輸入名稱",
             preferredStyle: .alert)
        alertController.addTextField { textField in
           textField.placeholder = "名稱"
        }
         // 建立[確認]按鈕
         let okAction = UIAlertAction(
             title: "確認",
             style: .default,
             handler: {
             (action: UIAlertAction!) -> Void in
                 guard let textField = alertController.textFields?[0].text,
                       textField != "" else { return }
                 let lut = Lut(name: textField, bright: self.editLightSlider.value, contrast: self.editContrastSlider.value)
                 self.luts.append(lut)
                 self.saveLutToUserDefeault(lut)
                 print(lut)
                 print(self.luts)
         })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
         // 顯示提示框
        self.present(
           alertController,
           animated: true,
           completion: nil)
    }
    // 儲存 Lut 對象
    func saveLutToUserDefeault(_ lut: Lut) {
        let userDefaults = UserDefaults.standard
        // 將 Lut 對象轉換為字典
        let lutData: [String: Any] = [
            "name": lut.name,
            "brightness": lut.bright,
            "contrast": lut.contrast
        ]
        // 儲存字典到 UserDefaults
        if var savedLuts = userDefaults.array(forKey: "luts") as? [[String: Any]] {
            savedLuts.append(lutData)
            userDefaults.set(savedLuts, forKey: "luts")
        } else {
            let newLuts = [lutData]
            userDefaults.set(newLuts, forKey: "luts")
        }
        // 保存變更
        userDefaults.synchronize()
    }
}
