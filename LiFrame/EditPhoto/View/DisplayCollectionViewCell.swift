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
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(afterLutImageView)
        contentView.backgroundColor = .PointColor

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
