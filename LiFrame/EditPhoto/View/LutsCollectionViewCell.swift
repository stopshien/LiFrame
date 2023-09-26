//
//  LutsCollectionViewCell.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/16.
//

import UIKit

class LutsCollectionViewCell: UICollectionViewCell {
    let lutImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    let lutLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lutImageView)
        addSubview(lutLabel)
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setLayout() {
        // 設置約束，您可以根據需要進行調整
        NSLayoutConstraint.activate([
            lutImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            lutImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            lutImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            lutImageView.bottomAnchor.constraint(equalTo: bottomAnchor , constant: -20),
            lutLabel.topAnchor.constraint(equalTo: lutImageView.bottomAnchor, constant: 5),
            lutLabel.centerXAnchor.constraint(equalTo: lutImageView.centerXAnchor),
            lutLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            lutLabel.widthAnchor.constraint(equalTo: lutImageView.widthAnchor, multiplier: 1.1)
        ])
    }

}
