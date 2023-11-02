//
//  BlackListTableViewCell.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/10/1.
//

import UIKit

class BlockListTableViewCell: UITableViewCell {
    let blockName: UILabel = {
        let label = UILabel()
        label.textColor = .mainLabelColor
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(blockName)
        NSLayoutConstraint.activate([
            blockName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            blockName.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        backgroundColor = .pointColor
        selectionStyle = .none
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
