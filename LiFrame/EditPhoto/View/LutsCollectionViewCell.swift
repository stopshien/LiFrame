//
//  LutsCollectionViewCell.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/16.
//

import UIKit

class LutsCollectionViewCell: UICollectionViewCell {
    let lutLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .green
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lutLabel)
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setLayout() {
        // 設置約束，您可以根據需要進行調整
        NSLayoutConstraint.activate([
            lutLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            lutLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            lutLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            lutLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }

}
