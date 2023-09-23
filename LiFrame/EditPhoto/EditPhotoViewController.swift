//
//  EditPhotoViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/14.
//

import UIKit
import PhotosUI

class EditPhotoViewController: UIViewController, PHPickerViewControllerDelegate {
    var configuration = PHPickerConfiguration()
    lazy var singleEditPicker = PHPickerViewController(configuration: configuration)
    let editPhotoButton: UIButton = {
        let button = UIButton()
        button.isSelected = false
        button.setTitle("    修圖", for: .normal)
//        button.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 25)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .PointColor
        button.tintColor = .white
        button.layer.borderColor = UIColor.systemGray5.cgColor
        button.layer.borderWidth = 5
        let configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 50))
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        return button
    }()
    let syncEditButton: UIButton = {
        let button = UIButton()
        button.isSelected = false
        button.setTitle("同步化", for: .normal)
//        button.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 20)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemGray6, for: .highlighted)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .mainColor
        button.tintColor = .PointColor
        button.layer.borderColor = UIColor.systemGray5.cgColor
        button.layer.borderWidth = 5
        let configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 50))
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        return button
    }()
    let seeLibraryButton: UIButton = {
        let button = UIButton()
        button.isSelected = false
        button.setTitle("相簿", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
//        button.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        button.setTitleColor(.PointColor, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .secondColor
        button.tintColor = .white
        button.layer.borderColor = UIColor.systemGray5.cgColor
        button.layer.borderWidth = 5
        let configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 50))
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        return button
    }()
    // 生命週期
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ""
        view.backgroundColor = .mainColor
        configuration.filter = .images
        singleEditPicker.delegate = self
        setEditPhotoViewLayout()
    }
    func setEditPhotoViewLayout() {
        view.addSubview(editPhotoButton)
        view.addSubview(seeLibraryButton)
        view.addSubview(syncEditButton)
        editPhotoButton.addTarget(self, action: #selector(tappedEdit), for: .touchUpInside)
        seeLibraryButton.addTarget(self, action: #selector(tappedSeeLibrary), for: .touchUpInside)
        syncEditButton.addTarget(self, action: #selector(tappedSyncEdit), for: .touchUpInside)
        NSLayoutConstraint.activate([
            editPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            editPhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -100),
            editPhotoButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            editPhotoButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            syncEditButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 70),
            syncEditButton.topAnchor.constraint(equalTo: editPhotoButton.centerYAnchor),
            syncEditButton.widthAnchor.constraint(equalTo: editPhotoButton.widthAnchor, multiplier: 0.8),
            syncEditButton.heightAnchor.constraint(equalTo: editPhotoButton.widthAnchor, multiplier: 0.8),
            seeLibraryButton.topAnchor.constraint(equalTo: syncEditButton.centerYAnchor, constant: 0),
            seeLibraryButton.trailingAnchor.constraint(equalTo: syncEditButton.leadingAnchor, constant: 80),
            seeLibraryButton.widthAnchor.constraint(equalTo: editPhotoButton.widthAnchor, multiplier: 0.5),
            seeLibraryButton.heightAnchor.constraint(equalTo: editPhotoButton.widthAnchor, multiplier: 0.5)
        ])
        editPhotoButton.layer.cornerRadius = view.frame.width/2
        syncEditButton.layer.cornerRadius = view.frame.width/2*0.8
        seeLibraryButton.layer.cornerRadius = view.frame.width/2*0.5
    }
    @objc func tappedEdit() {
        present(singleEditPicker, animated: true)
    }
    @objc func tappedSeeLibrary() {
        configuration.selectionLimit = 0
        let pickerForLibrary = PHPickerViewController(configuration: configuration)
        pickerForLibrary.view.tag = 2
        pickerForLibrary.delegate = self
        present(pickerForLibrary, animated: true)
    }
    @objc func tappedSyncEdit() {
        let lutVC = LutViewController()
        present(lutVC, animated: true)
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let itemProviders = results.map(\.itemProvider)
        if picker == self.singleEditPicker {
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
        dismiss(animated: true)
    }
}
