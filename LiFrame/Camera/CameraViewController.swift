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
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainLabelColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.PointColor.cgColor
        button.layer.borderWidth = 1.3
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return button
    }()
    let originalCamera: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("直接拍攝", for: .normal)
        button.setTitleColor(.mainLabelColor, for: .normal)
        button.backgroundColor = .mainColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.mainLabelColor.cgColor
        button.layer.borderWidth = 1.3
        button.addShadow()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return button
    }()
    let addPhotoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "選擇照片作為模板"
        label.textColor = .mainLabelColor
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.layer.borderWidth = 0
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.cornerRadius = 8
        return label
    }()
    let liFrameCamera: UIButton = {
        let button = UIButton()
        button.addShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 70, weight: .bold)
        button.setTitleColor(.mainLabelColor, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.mainLabelColor.cgColor
        button.layer.borderWidth = 3
        button.clipsToBounds = true
        return button
    }()
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        imageView.image = UIImage(named: "backgroundImage")
        return imageView
    }()
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.alpha = 1
        view.layer.cornerRadius = 0
        view.clipsToBounds = true
        view.frame = CGRect(x: 0, y: 0 , width: Int(fullScreenSize.width), height: Int(fullScreenSize.height))
        return view
    }()
    let flashButton: UIButton = {
        let button = UIButton()
        button.isSelected = false
        button.setImage(UIImage(systemName: "bolt.slash.fill"), for: .normal)
        button.setImage(UIImage(systemName: "bolt.fill"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 4
        let configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20))
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        return button
    }()
    let shutterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "camera.circle"), for: .normal)
        button.setImage(UIImage(systemName: "camera.circle.fill"), for: .highlighted)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0
        let configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 120))
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        return button
    }()
    let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "figure.walk"), for: .normal)
        button.setImage(UIImage(systemName: "figure.wave"), for: .highlighted)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 4
        return button
    }()
    let alphaSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0.5
        slider.isContinuous = true
        slider.minimumTrackTintColor = .white
        slider.minimumValueImage = UIImage(systemName: "moonphase.last.quarter.inverse")
        slider.tintColor = .white
        return slider
    }()
    let imagesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.tintColor = .white
        let configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 50))
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        return button
    }()
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ""
        // 相簿選擇相片
        configuration.filter = .images
        setLayout()
        flashButton.addTarget(self, action: #selector(tappedFlash), for: .touchUpInside)
        shutterButton.addTarget(self, action: #selector(tappedShutter), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(tappedCancel), for: .touchUpInside)
        alphaSlider.addTarget(self, action: #selector(alphaMove), for: .valueChanged)
        imagesButton.addTarget(self, action: #selector(tappedImageButton), for: .touchUpInside)
        liFrameCamera.addTarget(self, action: #selector(choosePhoto), for: .touchUpInside)
        originalCamera.addTarget(self, action: #selector(intoOriginalCamera), for: .touchUpInside)
        seePhotoLibrary.addTarget(self, action: #selector(intoLibaray), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        for subview in backgroundImageView.subviews {
                subview.removeFromSuperview()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        addFadingCircles()
    }
    func addFadingCircles() {
        let circleColors: [UIColor] = [.mainLabelColor, .PointColor, .mainColor, .mainLabelColor, .PointColor]
        let circleSizes: [CGFloat] = [40, 150, 80, 300, 200]
        let xposition: [CGFloat] = [80, 250, 80, 300, -10]
        let yposition: [CGFloat] = [80, 100, 300, 600, 470]
     for (index, color) in circleColors.enumerated() {
         let circleView = UIView()
         let circleSize = circleSizes[index]
         let xPoint = xposition[index]
         let yPoint = yposition[index]
         circleView.frame = CGRect(x: xPoint,
                                   y: yPoint,
                                   width: circleSize, height: circleSize)

               circleView.backgroundColor = color
               circleView.layer.cornerRadius = circleSize / 2
               circleView.alpha = 0.0 // 設置初始透明度為 0

               backgroundImageView.addSubview(circleView)

         UIView.animate(withDuration: 0.6, delay: Double(index) * 0.2, animations: {
                   circleView.alpha = 0.5 // 將透明度漸變為 0.5
               })
           }
       }
    @objc func tappedImageButton() {
        print("為了Demo方便，暫時先用可以選兩張的樣式，包板時改過來")
        configuration.selectionLimit = 0
        let pickerForLibrary = PHPickerViewController(configuration: configuration)
        pickerForLibrary.view.tag = 2
        pickerForLibrary.delegate = self
        imageCameraPicker.present(pickerForLibrary, animated: true)
    }
    @objc func alphaMove() {
        layerImageView?.alpha = CGFloat(alphaSlider.value)
    }
    @objc func intoLibaray() {
        let imagePickerController = UIImagePickerController()
        // 資料來源為圖片庫
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.view.tag = 2
        // 開啟ImagePickerController
        present(imagePickerController, animated: true, completion: nil)
    }
    @objc func intoOriginalCamera() {
        // 設定相機
        imageCameraPicker.sourceType = .camera
        setCameraUI()
        setCameraLayout()
        imageCameraPicker.delegate = self
        imageCameraPicker.showsCameraControls = false
        alphaSlider.isHidden = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // 開啟相機
            self.show(self.imageCameraPicker, sender: self)
        }
    }
    @objc func choosePhoto() {
        alphaSlider.isHidden = false
        alphaSlider.value = 0.45
        configuration.selectionLimit = 1
        let liFramePicker = PHPickerViewController(configuration: configuration)
        liFramePicker.view.tag = 1
        liFramePicker.delegate = self
        present(liFramePicker, animated: true)
    }
    func setLayout() {
        view.addSubview(backgroundImageView)
        view.addSubview(backgroundView)
        backgroundView.addSubview(liFrameCamera)
        backgroundView.addSubview(addPhotoLabel)
        backgroundView.addSubview(seePhotoLibrary)
        backgroundView.addSubview(originalCamera)
        NSLayoutConstraint.activate([
            liFrameCamera.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            liFrameCamera.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: -80),
            liFrameCamera.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 1/2),
            liFrameCamera.heightAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 1/2),
            addPhotoLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            addPhotoLabel.widthAnchor.constraint(equalTo: liFrameCamera.widthAnchor, multiplier: 1),
            addPhotoLabel.topAnchor.constraint(equalTo: liFrameCamera.bottomAnchor, constant: 30),
            originalCamera.topAnchor.constraint(equalTo: addPhotoLabel.bottomAnchor, constant: 80),
            originalCamera.widthAnchor.constraint(equalTo: liFrameCamera.widthAnchor, multiplier: 1.25),
            originalCamera.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            originalCamera.heightAnchor.constraint(equalToConstant: 35),
            seePhotoLibrary.topAnchor.constraint(equalTo: originalCamera.bottomAnchor, constant: 30),
            seePhotoLibrary.widthAnchor.constraint(equalTo: liFrameCamera.widthAnchor, multiplier: 1.25),
            seePhotoLibrary.heightAnchor.constraint(equalToConstant: 35),
            seePhotoLibrary.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        liFrameCamera.layer.cornerRadius = backgroundView.frame.width/2/2
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
                    var unrotatedImage = image

                    if image.size.width > image.size.height {
                        unrotatedImage = image.rotateToCorrectOrientation(.right)
                    } else {
                        unrotatedImage = image.rotateToCorrectOrientation(.up)
                    }
                    if picker.view.tag == 1 {
                    // 設定相機
                    self.imageCameraPicker.sourceType = .camera
                    self.setCameraUI()
                    self.setCameraLayout()
                    self.imageCameraPicker.delegate = self
                    self.imageCameraPicker.showsCameraControls = false
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            let imageView = UIImageView(image: unrotatedImage)
                            let screenSize = UIScreen.main.bounds
                            self.layerImageView = imageView
                            guard let layerImageView = self.layerImageView else { return }
                            layerImageView.alpha = 0.45
                            // 開啟相機
                            if let layer = self.imageCameraPicker.cameraOverlayView {
                                layer.addSubview(layerImageView)
                                layerImageView.contentMode = .scaleAspectFill
                                layerImageView.clipsToBounds = true
                                layerImageView.translatesAutoresizingMaskIntoConstraints = false
                                layerImageView.topAnchor.constraint(equalTo: layer.topAnchor).isActive = true
                                layerImageView.widthAnchor.constraint(equalTo: layer.widthAnchor).isActive = true
                                layerImageView.heightAnchor.constraint(equalTo: layer.widthAnchor, multiplier: 4/3).isActive = true
                            }
                        }
                        self.show(self.imageCameraPicker, sender: self)
                    } else {
                        self.layerImageView?.removeFromSuperview()
                        self.dismiss(animated: true)
                    }
                }
            }
        } else {
            self.layerImageView?.removeFromSuperview()
            dismiss(animated: true)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        if picker.view.tag == 2 {
            let detailImageVC = DetailImageViewController()
            detailImageVC.detailImage = image
            picker.present(detailImageVC, animated: true)
        } else {
            imagesButton.setImage(image, for: .normal)
            imagesButton.layer.borderWidth = 0
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    func setCameraUI() {
        imageCameraPicker.cameraFlashMode = .off
        flashButton.isSelected = false
        imageCameraPicker.view.addSubview(shutterButton)
        imageCameraPicker.view.addSubview(flashButton)
        imageCameraPicker.view.addSubview(cancelButton)
        imageCameraPicker.view.addSubview(alphaSlider)
        imageCameraPicker.view.addSubview(imagesButton)
    }
    func setCameraLayout() {
        NSLayoutConstraint.activate([
            shutterButton.centerYAnchor.constraint(equalTo: imageCameraPicker.view.centerYAnchor, constant: 250),
            shutterButton.centerXAnchor.constraint(equalTo: imageCameraPicker.view.centerXAnchor),
            shutterButton.widthAnchor.constraint(equalTo: imageCameraPicker.view.widthAnchor, multiplier: 0.35),
            flashButton.leadingAnchor.constraint(equalTo: shutterButton.trailingAnchor, constant: 30),
            flashButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10),
            flashButton.widthAnchor.constraint(equalTo: imageCameraPicker.view.widthAnchor, multiplier: 0.15),
            flashButton.heightAnchor.constraint(equalTo: imageCameraPicker.view.widthAnchor, multiplier: 0.15),
            cancelButton.leadingAnchor.constraint(equalTo: shutterButton.trailingAnchor, constant: 30),
            cancelButton.bottomAnchor.constraint(equalTo: alphaSlider.topAnchor, constant: -20),
            cancelButton.widthAnchor.constraint(equalTo: imageCameraPicker.view.widthAnchor, multiplier: 0.15),
            cancelButton.heightAnchor.constraint(equalTo: imageCameraPicker.view.widthAnchor, multiplier: 0.15),
            alphaSlider.topAnchor.constraint(lessThanOrEqualTo: shutterButton.bottomAnchor, constant: 50),
            alphaSlider.bottomAnchor.constraint(lessThanOrEqualTo: imageCameraPicker.view.bottomAnchor, constant: -10),
            alphaSlider.leadingAnchor.constraint(equalTo: imageCameraPicker.view.leadingAnchor, constant: 50),
            alphaSlider.trailingAnchor.constraint(equalTo: imageCameraPicker.view.trailingAnchor, constant: -60),
            imagesButton.trailingAnchor.constraint(equalTo: shutterButton.leadingAnchor, constant: -30),
            imagesButton.bottomAnchor.constraint(equalTo: alphaSlider.topAnchor, constant: -20),
            imagesButton.widthAnchor.constraint(equalTo: imageCameraPicker.view.widthAnchor, multiplier: 0.15),
            imagesButton.heightAnchor.constraint(equalTo: imageCameraPicker.view.widthAnchor, multiplier: 0.15)
        ])
    }
    @objc func tappedShutter() {
        imageCameraPicker.cameraDevice = .rear
        imageCameraPicker.takePicture()
        let shutterView: UIView = {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            view.backgroundColor = .black
            return view
        }()
        imageCameraPicker.view.addSubview(shutterView)
        shutterView.alpha = 0.6
        UIView.animate(withDuration: 0.2) {
            shutterView.alpha = 0
        }
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
