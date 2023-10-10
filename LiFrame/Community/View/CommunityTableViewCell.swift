//
//  CommunityTableViewCell.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/17.
//

import UIKit

class CommunityTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var backgroundViewForCell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundViewForCell.clipsToBounds = true
        backgroundViewForCell.layer.cornerRadius = 8
        backgroundViewForCell.layer.borderColor = UIColor.mainLabelColor.cgColor
        backgroundViewForCell.layer.borderWidth = 1
        backgroundViewForCell.backgroundColor = .secondColor
        backgroundViewForCell.addShadow()
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel.textColor = .mainLabelColor
        createTimeLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        createTimeLabel.textColor = .gray
        selectionStyle = .none
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
