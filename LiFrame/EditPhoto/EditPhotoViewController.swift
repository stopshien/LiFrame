//
//  EditPhotoViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/14.
//

import UIKit
import PhotosUI

class EditPhotoViewController: UIViewController, PHPickerViewControllerDelegate {
    var luts = [Lut]()
    var currentLut: Lut?
    var configuration = PHPickerConfiguration()
    lazy var singleEditPicker = PHPickerViewController(configuration: configuration)
    // 生命週期
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration.filter = .images
        singleEditPicker.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        if let luts = LutManager.shared.loadLuts() {
            self.luts = luts
        } else {
            luts = []
        }
    }
    @IBAction func lutButton(_ sender: Any) {
    }
    @IBAction func syncEditButton(_ sender: Any) {

        syncEditView()

    }
    @IBAction func choosePhoto(_ sender: Any) {
        present(singleEditPicker, animated: true)
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
        } else {
            var processedImages: [UIImage] = []
            let semaphore = DispatchSemaphore(value: 1)
            for itemProvider in itemProviders {
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    semaphore.wait()
                    itemProvider.loadObject(ofClass: UIImage.self) {[weak self] (image, error) in
                        guard let self = self, let image = image as? UIImage else { return }
                        guard let currentLut = currentLut else { return }
                        defer {
                            semaphore.signal() // 釋放信號量，允許下一張圖片處理
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
            dismiss(animated: true)
        }
    }
    func syncEditView() {
        let backview: UIView = {
            let view = UIView()
            view.backgroundColor = .gray
            view.alpha = 0.7
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
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
            collectionView.backgroundColor = .cyan
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.delegate = self
            collectionView.dataSource = self
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 10 // 行之間的最小間距
            layout.minimumInteritemSpacing = 0 // 元素之間的最小間距
            layout.itemSize = CGSize(width: 80, height: 80)
            // 註冊 cell 類型
            collectionView.register(LutsCollectionViewCell.self, forCellWithReuseIdentifier: "LutsCollectionViewCell")
            return collectionView
        }()
        view.addSubview(backview)
        view.addSubview(lutView)
        view.addSubview(lutsCollectionView) // 將 collectionView 添加到視圖中
        NSLayoutConstraint.activate([
            backview.topAnchor.constraint(equalTo: view.bottomAnchor),
            backview.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            backview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            lutView.bottomAnchor.constraint(equalTo: backview.bottomAnchor),
            lutView.heightAnchor.constraint(equalTo: backview.heightAnchor, multiplier: 0.3),
            lutView.widthAnchor.constraint(equalTo: backview.widthAnchor),
            // 設置 collectionView 的約束
            lutsCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor), // 水平居中
            lutsCollectionView.centerYAnchor.constraint(equalTo: lutView.centerYAnchor,constant: -20), // 垂直居中-20
            lutsCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1), // 寬度為視圖寬度的100%
            lutsCollectionView.heightAnchor.constraint(equalTo: lutView.heightAnchor, multiplier: 0.5) // 高度為 lutView 高度的一半
        ])
        // 先強制部局讓他到螢幕下方的位置
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.7) {
            backview.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            self.view.layoutIfNeeded() // 強制視圖重新布局以觸發動畫
        }
    }
}

extension EditPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        luts.count
    }    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LutsCollectionViewCell", for: indexPath) as? LutsCollectionViewCell else { return LutsCollectionViewCell() }

        cell.lutLabel.text = luts[indexPath.row].name
        cell.lutLabel.backgroundColor = .orange
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
}
