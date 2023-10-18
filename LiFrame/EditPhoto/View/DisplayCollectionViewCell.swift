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
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        // 暫時先不用
        button.isHidden = true
        button.tintColor = .mainLabelColor
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(afterLutImageView)
        addSubview(addButton)
        addButton.addTarget(self, action: #selector(tappedSelect), for: .touchUpInside)
        afterLutImageView.addShadow(color: .mainLabelColor, offset: CGSize(width: 10, height: 10))
        setImageViewLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func tappedSelect() {
        addButton.isSelected.toggle()
    }
    func setImageViewLayout() {
        NSLayoutConstraint.activate([
            afterLutImageView.topAnchor.constraint(equalTo: topAnchor),
            afterLutImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            afterLutImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            afterLutImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            addButton.bottomAnchor.constraint(equalTo: afterLutImageView.bottomAnchor, constant: -10),
            addButton.trailingAnchor.constraint(equalTo: afterLutImageView.trailingAnchor, constant: -10)
        ])
    }
}
