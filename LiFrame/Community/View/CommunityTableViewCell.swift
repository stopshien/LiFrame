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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundViewForCell.clipsToBounds = true
        backgroundViewForCell.layer.cornerRadius = 8
        backgroundViewForCell.layer.borderColor = UIColor.black.cgColor
        backgroundViewForCell.layer.borderWidth = 1
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        createTimeLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        createTimeLabel.textColor = .gray
        // Configure the view for the selected state
    }

}
