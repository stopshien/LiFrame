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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "...", style: .plain, target: self, action: #selector(pressMore))
    }
    @objc func pressMore() {
        let controller = UIAlertController(title: "黑名單", message: nil, preferredStyle: .actionSheet)
           let addBlackLitAction = UIAlertAction(title: "加入黑名單", style: .default) { action in
               print(self.postDetail?.appleID)
           }
           controller.addAction(addBlackLitAction)
        let watchBlackLitAction = UIAlertAction(title: "查看黑名單", style: .default) { action in
            print(action.title)
        }
        controller.addAction(watchBlackLitAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true)
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
