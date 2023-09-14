//
//  ViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/13.
//

import UIKit
import PhotosUI

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
//        picker.dismiss(animated: true)
        let itemProviders = results.map(\.itemProvider)
        if let itemProvider = itemProviders.first, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) {[weak self] (image, error) in
                DispatchQueue.main.async {
                    guard let self = self, let image = image as? UIImage else { return }
                    // 設定相機
                    let imageCameraPicker = UIImagePickerController()
                    imageCameraPicker.sourceType = .camera
                    imageCameraPicker.delegate = self
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        let smallImage = self.resizeImage(image: image, width: 320)
                        let imageView =  UIImageView(image: smallImage)
                        imageView.frame = CGRect(x: 0, y: 120, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*4/3)
                        imageView.alpha = 0.3
                        //開啟相機
                        self.show(imageCameraPicker, sender: self)
                    }
                }
            }
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        dismiss(animated: true, completion: nil)
    }
    // 重新調整大小
    func resizeImage(image: UIImage, width: CGFloat) -> UIImage {
            let size = CGSize(width: width, height:
                image.size.height * width / image.size.width)
            let renderer = UIGraphicsImageRenderer(size: size)
            let newImage = renderer.image { (context) in
                image.draw(in: renderer.format.bounds)
            }
            return newImage
    }
}
