//
//  PostDetailViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/17.
//

import UIKit
import Kingfisher

class PostDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var postDetail: Posts?
    @IBOutlet weak var postDetailTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        postDetailTableView.dataSource = self
        postDetailTableView.delegate = self
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = postDetailTableView.dequeueReusableCell(withIdentifier: "PostDetailTableViewCell", for: indexPath) as? PostDetailTableViewCell,
               let postDetail = postDetail {
                cell.titleLabel.text = postDetail.title
                cell.createTimeLabel.text = "發布時間：\(postDetail.createdTime)"
                cell.contentLabel.text = postDetail.content
                cell.posterNameLabel.text = "由\(postDetail.name)發布"
                return cell
            }
        } else {
            if let cell = postDetailTableView.dequeueReusableCell(withIdentifier: "PostImageViewTableViewCell", for: indexPath) as? PostImageViewTableViewCell,
               let postDetail = postDetail,
               let image = postDetail.image {
                cell.postImageView.kf.setImage(with: URL(string: image))
                return cell
            }
        }
        return UITableViewCell()
    }
}
