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
    var blackList: [BlackList] = []
    @IBOutlet weak var postDetailTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        postDetailTableView.dataSource = self
        postDetailTableView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "...", style: .plain, target: self, action: #selector(pressMore))
        // 判斷使否已經登入,userData 都存在 UserData 中
            if let userID = UserData.shared.getUserAppleID() {
                navigationItem.rightBarButtonItem?.isHidden = false
            } else {
                navigationItem.rightBarButtonItem?.isHidden = true
            }
        // 從 firebase 更新黑名單
        UserData.shared.getUserDataFromFirebase { user in
            if let black = user?.blackList {
                self.blackList = black
            }
        }
    }
    // TODO: - 從firebase 拿黑名單
    @objc func pressMore() {
        let controller = UIAlertController(title: "黑名單", message: nil, preferredStyle: .actionSheet)
           let addBlackListAction = UIAlertAction(title: "加入黑名單", style: .default) { action in
               if let blockUserAppleID = self.postDetail?.appleID,
                  let userName = self.postDetail?.name {
                   let wannaBlockUser = BlackList(blockedName: userName, blockedAppleID: blockUserAppleID)
                   if !self.blackList.contains(where: { $0.blockedName == wannaBlockUser.blockedName && $0.blockedAppleID == wannaBlockUser.blockedAppleID }) {
                       self.blackList.append(wannaBlockUser)
                       print("加進黑名單")
                       print(self.blackList)
                   }
                   let blackListDictArray = self.blackList.map { blackList -> [String: Any] in
                       return [
                           "blockedName": blackList.blockedName,
                           "blockedAppleID": blackList.blockedAppleID
                       ]
                   }
                   FirebaseManager().updateBlackListForFirebase(key: "blacklist", value: blackListDictArray)
                   self.navigationController?.popViewController(animated: true)
               }
           }
           controller.addAction(addBlackListAction)
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
