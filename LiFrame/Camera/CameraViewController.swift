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
    var configuration = PHPickerConfiguration()
    static let fullScreenSize = UIScreen.main.bounds
    var layerImageView: UIImageView?
    let seePhotoLibrary: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("查看相簿", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    let originalCamera: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("直接拍攝", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    let addPhotoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "選擇照片作為模板"
        label.textColor = .white
        label.backgroundColor = .black
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.cornerRadius = 8
        return label
    }()
    let liFrameCamera: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 70, weight: .bold)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .white
        button.clipsToBounds = true
        return button
    }()
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.9
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.frame = CGRect(x: 0, y: Int(fullScreenSize.height/4) , width: Int(fullScreenSize.width), height: Int(fullScreenSize.height/3))
        return view
    }()
    let flashButton: UIButton = {
        let button = UIButton()
        button.isSelected = false
        button.setImage(UIImage(systemName: "bolt.slash.fill"), for: .normal)
        button.setImage(UIImage(systemName: "bolt.fill"), for: .selected)
        button.frame = CGRect(x: 50, y: Int(fullScreenSize.height*0.8), width: 50, height: 50)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 5
        let configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20))
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        return button
    }()
    let shutter: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera.circle"), for: .normal)
        button.setImage(UIImage(systemName: "camera.circle.fill"), for: .highlighted)
        button.frame = CGRect(x: Int(fullScreenSize.width/2-50), y: Int(fullScreenSize.height*0.65), width: 100, height: 100)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 5
        let configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 200))
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        return button
    }()
    let cancel: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "figure.walk"), for: .normal)
        button.setImage(UIImage(systemName: "figure.wave"), for: .highlighted)
        button.frame = CGRect(x: Int(fullScreenSize.width-100), y: Int(fullScreenSize.height*0.8), width: 50, height: 50)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 5
        return button
    }()
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "相機"
        // 相簿選擇相片
        configuration.filter = .images
        setLayout()
        flashButton.addTarget(self, action: #selector(tappedFlash), for: .touchUpInside)
        shutter.addTarget(self, action: #selector(tappedShutter), for: .touchUpInside)
        cancel.addTarget(self, action: #selector(tappedCancel), for: .touchUpInside)
        liFrameCamera.addTarget(self, action: #selector(choosePhoto), for: .touchUpInside)
        originalCamera.addTarget(self, action: #selector(intoOriginalCamera), for: .touchUpInside)
        seePhotoLibrary.addTarget(self, action: #selector(intoLibaray), for: .touchUpInside)
    }
    @objc func intoLibaray() {
        configuration.selectionLimit = 1
        let pickerForOriginal = PHPickerViewController(configuration: configuration)
        pickerForOriginal.view.tag = 2
        pickerForOriginal.delegate = self
        present(pickerForOriginal, animated: true)
    }
    @objc func intoOriginalCamera() {
        // 設定相機
        imageCameraPicker.sourceType = .camera
        setCameraUI()
        imageCameraPicker.delegate = self
        imageCameraPicker.showsCameraControls = false
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // 開啟相機
            self.show(self.imageCameraPicker, sender: self)
        }
    }
    @objc func choosePhoto() {
        let liFramePicker = PHPickerViewController(configuration: configuration)
        liFramePicker.view.tag = 1
        liFramePicker.delegate = self
        present(liFramePicker, animated: true)
    }
    func setLayout() {
        view.backgroundColor = .systemGray4
        view.addSubview(backgroundView)
        backgroundView.addSubview(liFrameCamera)
        backgroundView.addSubview(addPhotoLabel)
        view.addSubview(seePhotoLibrary)
        view.addSubview(originalCamera)
        NSLayoutConstraint.activate([
            liFrameCamera.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            liFrameCamera.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: -30),
            liFrameCamera.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 1/2.5),
            liFrameCamera.heightAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 1/2.5),
            addPhotoLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            addPhotoLabel.widthAnchor.constraint(equalTo: liFrameCamera.widthAnchor, multiplier: 1),
            addPhotoLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: 80),
            originalCamera.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 100),
            originalCamera.widthAnchor.constraint(equalTo: liFrameCamera.widthAnchor),
            originalCamera.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            seePhotoLibrary.topAnchor.constraint(equalTo: originalCamera.bottomAnchor, constant: 30),
            seePhotoLibrary.widthAnchor.constraint(equalTo: liFrameCamera.widthAnchor),
            seePhotoLibrary.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        liFrameCamera.layer.cornerRadius = backgroundView.frame.width/2/2.5
        liFrameCamera.clipsToBounds = true
    }
}

extension CameraViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let itemProviders = results.map(\.itemProvider)
        if let itemProvider = itemProviders.first, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) {
                [weak self] (image, error) in
                DispatchQueue.main.async {
                    guard let self = self, let image = image as? UIImage else { return }
                    if picker.view.tag == 1 {
                    // 設定相機
                    self.imageCameraPicker.sourceType = .camera
                    self.setCameraUI()
                    self.imageCameraPicker.delegate = self
                    self.imageCameraPicker.showsCameraControls = false
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            let imageView =  UIImageView(image: image)
                            let screenSize = UIScreen.main.bounds
                            imageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.width/3*4)
                            self.layerImageView = imageView
                            guard let layerImageView = self.layerImageView else { return }
                            layerImageView.alpha = 0.3
                            // 開啟相機
                            self.imageCameraPicker.cameraOverlayView?.addSubview(layerImageView)
                            self.imageCameraPicker.cameraOverlayView?.translatesAutoresizingMaskIntoConstraints = false
                        } else {
                            self.dismiss(animated: true)
                        }
                        self.show(self.imageCameraPicker, sender: self)
                    }
                }
            }
        } else {
            dismiss(animated: true)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        dismiss(animated: true)
    }
    func setCameraUI() {
        imageCameraPicker.cameraFlashMode = .off
        flashButton.isSelected = false
        imageCameraPicker.view.addSubview(shutter)
        imageCameraPicker.view.addSubview(flashButton)
        imageCameraPicker.view.addSubview(cancel)
    }
    @objc func tappedShutter() {
        imageCameraPicker.cameraDevice = .rear
        imageCameraPicker.takePicture()
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
        layerImageView?.removeFromSuperview()
        dismiss(animated: true)
    }
}
