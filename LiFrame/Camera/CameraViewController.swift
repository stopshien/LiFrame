//
//  ViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/13.
//

import UIKit
import PhotosUI

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imageCameraPicker = UIImagePickerController()
    var layerImageView: UIImageView?
    let flashButton: UIButton = {
        let button = UIButton()
        button.isSelected = false
        button.setImage(UIImage(systemName: "bolt.slash.fill"), for: .normal)
        button.setImage(UIImage(systemName: "bolt.fill"), for: .selected)
        button.frame = CGRect(x: 100, y: 600, width: 50, height: 50)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        flashButton.addTarget(self, action: #selector(tappedFlash), for: .touchUpInside)
    }
    @IBAction func choosePhotoToCamera(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
//        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension CameraViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let itemProviders = results.map(\.itemProvider)
        if let itemProvider = itemProviders.first, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                DispatchQueue.main.async {
                    guard let self = self, let image = image as? UIImage else { return }
                    // 設定相機
                    self.imageCameraPicker.sourceType = .camera
                    self.setButtonsUI()
                    self.imageCameraPicker.delegate = self
                    self.imageCameraPicker.showsCameraControls = false
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                        let smallImage = self.resizeImage(image: image, width: 320)
                        let imageView =  UIImageView(image: image)
                        let screenSize = UIScreen.main.bounds
                        imageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.width/3*4)
                        self.layerImageView = imageView
                        guard let layerImageView = self.layerImageView else { return }
                        layerImageView.alpha = 0.3
                        // 開啟相機
                        self.imageCameraPicker.cameraOverlayView?.addSubview(layerImageView)
                        self.imageCameraPicker.cameraOverlayView?.translatesAutoresizingMaskIntoConstraints = false
                        self.show(self.imageCameraPicker, sender: self)
                    }
                }
            }
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }

        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
//    // 重新調整大小
//    func resizeImage(image: UIImage, width: CGFloat) -> UIImage {
//            let size = CGSize(width: width, height:
//                image.size.height * width / image.size.width)
//            let renderer = UIGraphicsImageRenderer(size: size)
//            let newImage = renderer.image { (context) in
//                image.draw(in: renderer.format.bounds)
//            }
//            return newImage
//    }
    func setButtonsUI() {
        let shutter: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "camera.circle"), for: .normal)
            button.addTarget(self, action: #selector(tappedShutter), for: .touchUpInside)
            button.frame = CGRect(x: 200, y: 600, width: 50, height: 50)
            button.tintColor = .white
            let configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 200))
            button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
            return button
        }()
        let cancel: UIButton = {
            let button = UIButton()
            button.setTitle("Cancel", for: .normal)
            button.addTarget(self, action: #selector(tappedCancel), for: .touchUpInside)
            button.frame = CGRect(x: 200, y: 650, width: 50, height: 50)
            button.tintColor = .white
//            let configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 200))
//            button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
            return button
        }()
        imageCameraPicker.cameraFlashMode = .off
        flashButton.isSelected = false
        imageCameraPicker.view.addSubview(shutter)
        imageCameraPicker.view.addSubview(flashButton)
        imageCameraPicker.view.addSubview(cancel)
    }
    @objc func tappedShutter() {
        imageCameraPicker.cameraDevice = .rear
        imageCameraPicker.takePicture()
        layerImageView?.removeFromSuperview()
    }
    @objc func tappedFlash() {
        flashButton.isSelected.toggle()
        if imageCameraPicker.cameraFlashMode == .off {
            imageCameraPicker.cameraFlashMode = .on
        } else {
            imageCameraPicker.cameraFlashMode = .off
        }
    }
    @objc func tappedCancel() {
        dismiss(animated: true)
    }
}
