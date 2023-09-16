//
//  EditPhotoViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/14.
//

import UIKit
import PhotosUI

class EditPhotoViewController: UIViewController, PHPickerViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func lutButton(_ sender: Any) {
    }
    @IBAction func syncEditButton(_ sender: Any) {
    }
    @IBAction func choosePhoto(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
//        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let itemProviders = results.map(\.itemProvider)
        if let itemProvider = itemProviders.first, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) {[weak self] (image, error) in
                DispatchQueue.main.async {
                    guard let self = self, let image = image as? UIImage else { return }
                    let editVC = EditViewController()
                    self.navigationController?.pushViewController(editVC, animated: true)
                    editVC.editImage = image
                    picker.dismiss(animated: true)
                }
            }
        }
    }
}
