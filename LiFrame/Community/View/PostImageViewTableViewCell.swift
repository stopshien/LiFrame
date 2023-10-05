//
//  PostImageViewTableViewCell.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/18.
//

import UIKit

class PostImageViewTableViewCell: UITableViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .PointColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
