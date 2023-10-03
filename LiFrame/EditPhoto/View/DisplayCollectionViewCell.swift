//
//  DisplayCollectionViewCell.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/10/2.
//

import UIKit

class DisplayCollectionViewCell: UICollectionViewCell {
    let afterLutImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(afterLutImageView)
        setImageViewLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setImageViewLayout() {
        NSLayoutConstraint.activate([
            afterLutImageView.topAnchor.constraint(equalTo: topAnchor),
            afterLutImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            afterLutImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            afterLutImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
