//
//  LutViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/21.
//

import UIKit
import PhotosUI

class LutViewController: UIViewController, PHPickerViewControllerDelegate {
    var luts = [Lut]()
    var currentLut: Lut?
    var configuration = PHPickerConfiguration()
    let backview: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.alpha = 0.7
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let dismissButton: UIButton = {
       let button = UIButton()
        button.setTitle("X", for: .normal)
        button.setTitleColor(.systemGray6, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedDismiss), for: .touchUpInside)
        return button
    }()
    let lutView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let lutsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .gray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10 // 行之間的最小間距
        layout.minimumInteritemSpacing = 0 // 元素之間的最小間距
        layout.itemSize = CGSize(width: 80, height: 80)
        // 註冊 cell 類型
        collectionView.register(LutsCollectionViewCell.self, forCellWithReuseIdentifier: "LutsCollectionViewCell")
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        lutsCollectionView.delegate = self
        lutsCollectionView.dataSource = self
        view.addSubview(backview)
        view.addSubview(lutView)
        view.addSubview(lutsCollectionView) // 將 collectionView 添加到視圖中
        backview.addSubview(dismissButton)
        NSLayoutConstraint.activate([
            backview.topAnchor.constraint(equalTo: view.topAnchor),
            backview.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            backview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            lutView.bottomAnchor.constraint(equalTo: backview.bottomAnchor),
            lutView.heightAnchor.constraint(equalTo: backview.heightAnchor, multiplier: 0.3),
            lutView.widthAnchor.constraint(equalTo: backview.widthAnchor),
            // 設置 collectionView 的約束
            lutsCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor), // 水平居中
            lutsCollectionView.centerYAnchor.constraint(equalTo: lutView.centerYAnchor, constant: -20),
            lutsCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            lutsCollectionView.heightAnchor.constraint(equalTo: lutView.heightAnchor, multiplier: 0.5),
            dismissButton.topAnchor.constraint(equalTo: backview.topAnchor, constant: 50),
            dismissButton.trailingAnchor.constraint(equalTo: backview.trailingAnchor, constant: -30),
            dismissButton.widthAnchor.constraint(equalToConstant: 30),
            dismissButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    override func viewWillAppear(_ animated: Bool) {
        if let luts = LutManager.shared.loadLuts() {
            self.luts = luts
        } else {
            luts = []
        }
    }
    @objc func tappedDismiss() {
        dismiss(animated: true)
    }
}
extension LutViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        luts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LutsCollectionViewCell", for: indexPath) as? LutsCollectionViewCell else { return LutsCollectionViewCell() }

        cell.lutLabel.text = luts[indexPath.row].name
        cell.lutLabel.backgroundColor = .white
        cell.lutLabel.layer.cornerRadius = 40
        cell.lutLabel.clipsToBounds = true
        cell.lutLabel.layer.borderColor = UIColor.black.cgColor
        cell.lutLabel.layer.borderWidth = 1
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentLut = luts[indexPath.row]
        configuration.filter = .images
        configuration.selectionLimit = 0
        let pickerForSync = PHPickerViewController(configuration: configuration)
        pickerForSync.delegate = self
        present(pickerForSync, animated: true)
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        var processedImages: [UIImage] = []
        let semaphore = DispatchSemaphore(value: 1)
        let itemProviders = results.map(\.itemProvider)
        for itemProvider in itemProviders {
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                semaphore.wait()
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    guard let self = self, let image = image as? UIImage else { return }
                    guard let currentLut = currentLut else { return }
                    defer {
                        // 允許下一張圖片處理
                        semaphore.signal()
                    }
                    // 處理光線和對比，替換下面的數值為您想要的值
                    let brightness: Float = currentLut.bright
                    let contrast: Float = currentLut.contrast
                    if let processedImage = LutManager.shared.applyBrightnessAndContrast(image, brightness: brightness, contrast: contrast) {
                        processedImages.append(processedImage)
                    }
                    if processedImages.count == itemProviders.count {
                        LutManager.shared.saveImagesToPhotoLibrary(processedImages)
                    }
                }
            }
        }
        defer {
            dismiss(animated: true)
        }
    }
}
