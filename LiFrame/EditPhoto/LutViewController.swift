//
//  LutViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/21.
//

import UIKit
import PhotosUI
import CMHUD

class LutViewController: UIViewController {
    var luts = [Lut]()
    var currentLut: Lut?
    var originImage = [UIImage]()
    var afterLutImage: [UIImage] = []
    let backview: UIView = {
        let view = UIView()
        view.backgroundColor = .PointColor
        view.alpha = 0.8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("儲存", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.mainColor, for: .highlighted)
        button.backgroundColor = .mainLabelColor
        button.layer.cornerRadius = 10
        return button
    }()
    let displayCollectionView: UICollectionView = {
        let layout = CardLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        // 註冊 cell 類型
        collectionView.backgroundColor = .clear
        collectionView.register(DisplayCollectionViewCell.self, forCellWithReuseIdentifier: "DisplayCollectionViewCell")
        return collectionView
    }()
    let dismissButton: UIButton = {
       let button = UIButton()
        button.setTitle("X", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hexString: "#9E8A7B")
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedDismiss), for: .touchUpInside)
        return button
    }()
    let lutView: UIView = {
        let view = UIView()
        view.backgroundColor = .lutViewColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    let lutsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .lutCollectionViewColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10 // 行之間的最小間距
        layout.minimumInteritemSpacing = 0 // 元素之間的最小間距
        layout.itemSize = CGSize(width: 100, height: 110)
        // 註冊 cell 類型
        collectionView.register(LutsCollectionViewCell.self, forCellWithReuseIdentifier: "LutsCollectionViewCell")
        return collectionView
    }()
    let haveNoLutsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "尚未加入風格檔"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    let chooseLutLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "請選擇濾鏡"
        label.textColor = .mainLabelColor
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        lutsCollectionView.delegate = self
        lutsCollectionView.dataSource = self
        displayCollectionView.dataSource = self
        view.addSubview(backview)
        view.addSubview(lutView)
        view.addSubview(lutsCollectionView) // 將 collectionView 添加到視圖中
        view.addSubview(displayCollectionView)
        lutsCollectionView.addSubview(haveNoLutsLabel)
        view.addSubview(dismissButton)
        view.addSubview(chooseLutLabel)
        displayCollectionView.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(tappedSave), for: .touchUpInside)
        NSLayoutConstraint.activate([
            backview.topAnchor.constraint(equalTo: view.topAnchor),
            backview.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            backview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            lutView.bottomAnchor.constraint(equalTo: backview.bottomAnchor, constant: 20),
            lutView.heightAnchor.constraint(equalTo: backview.heightAnchor, multiplier: 0.3),
            lutView.widthAnchor.constraint(equalTo: backview.widthAnchor),
            // 設置 collectionView 的約束
            lutsCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor), // 水平居中
            lutsCollectionView.centerYAnchor.constraint(equalTo: lutView.centerYAnchor, constant: -20),
            lutsCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            lutsCollectionView.heightAnchor.constraint(equalTo: lutView.heightAnchor, multiplier: 0.65),
            dismissButton.topAnchor.constraint(equalTo: backview.topAnchor, constant: 50),
            dismissButton.trailingAnchor.constraint(equalTo: backview.trailingAnchor, constant: -30),
            dismissButton.widthAnchor.constraint(equalToConstant: 30),
            dismissButton.heightAnchor.constraint(equalToConstant: 30),
            haveNoLutsLabel.centerXAnchor.constraint(equalTo: lutsCollectionView.centerXAnchor),
            haveNoLutsLabel.centerYAnchor.constraint(equalTo: lutsCollectionView.centerYAnchor),
            displayCollectionView.topAnchor.constraint(equalTo: backview.topAnchor, constant: 20),
            displayCollectionView.widthAnchor.constraint(equalTo: backview.widthAnchor, multiplier: 1),
            displayCollectionView.bottomAnchor.constraint(equalTo: lutView.topAnchor),
            saveButton.bottomAnchor.constraint(lessThanOrEqualTo: lutView.topAnchor, constant: -15),
            saveButton.centerXAnchor.constraint(equalTo: lutView.centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: lutView.widthAnchor, multiplier: 0.3),
            chooseLutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chooseLutLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50)
        ])
    }
    override func viewWillAppear(_ animated: Bool) {
        if let luts = LutManager.shared.loadLuts() {
            self.luts = luts
        } else {
            luts = []
        }
        if luts.count == 0 {
            haveNoLutsLabel.isHidden = false
        } else {
            haveNoLutsLabel.isHidden = true
        }
        print(afterLutImage.count)
    }
    @objc func tappedDismiss() {
        dismiss(animated: true)
    }
    @objc func tappedSave() {
        LutManager.shared.saveImagesToPhotoLibrary(afterLutImage)
        dismiss(animated: true)
    }
}
extension LutViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == lutsCollectionView {
            return luts.count
        } else {
            return afterLutImage.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case lutsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LutsCollectionViewCell", for: indexPath) as? LutsCollectionViewCell,
                  let demoImage = UIImage(named: "lutDisplayImage") else { return LutsCollectionViewCell() }
            let demoForLutImage = LutManager.shared.applyLutToImage(demoImage, brightness: luts[indexPath.row].bright, contrast: luts[indexPath.row].contrast, saturation: luts[indexPath.row].saturation)
            cell.lutImageView.image = demoForLutImage
            cell.lutLabel.text = luts[indexPath.row].name
            cell.backgroundColor = .clear
            cell.lutImageView.layer.cornerRadius = 10
            return cell
        case displayCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisplayCollectionViewCell", for: indexPath) as? DisplayCollectionViewCell else { return DisplayCollectionViewCell() }
            cell.afterLutImageView.image = afterLutImage[indexPath.row]
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentLut = luts[indexPath.row]
        guard let currentLut = currentLut else { return }
        // 處理光線和對比，替換下面的數值為您想要的值
        var newImages = [UIImage]()
        let brightness: Float = currentLut.bright
        let contrast: Float = currentLut.contrast
        let saturation: Float = currentLut.saturation
        for image in originImage {
            if let processedImage = LutManager.shared.applyLutToImage(image, brightness: brightness, contrast: contrast, saturation: saturation) {
                newImages.append(processedImage)
            }
        }
        afterLutImage = newImages
        displayCollectionView.reloadData()
    }
}
