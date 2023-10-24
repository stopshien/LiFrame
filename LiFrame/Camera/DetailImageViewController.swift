//
//  DetailImageViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/10/12.
//

import UIKit

class DetailImageViewController: UIViewController {
    var detailImage: UIImage?
    var detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.addShadow(color: .mainLabelColor, offset: CGSize(width: 10, height: 10))
        return imageView
    }()
    let photoInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .black)
        return label
    }()
    let OKButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OK", for: .normal)
        button.tintColor = .pointColor
        button.backgroundColor = .mainLabelColor
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pointColor
        view.addSubview(detailImageView)
        view.addSubview(photoInfoLabel)
        view.addSubview(OKButton)
        OKButton.addTarget(self, action: #selector(tappedOK), for: .touchUpInside)
        if detailImage != nil {
            detailImageView.image = detailImage
        }
        NSLayoutConstraint.activate([
            detailImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            detailImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            detailImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            OKButton.topAnchor.constraint(greaterThanOrEqualTo: detailImageView.bottomAnchor, constant: 5),
            OKButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            OKButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            OKButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }

    @objc func tappedOK() {
        dismiss(animated: true)
    }
}
