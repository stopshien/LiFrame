//
//  PostDetailViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/17.
//

import UIKit
import Kingfisher
import FirebaseStorage

class PostDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var postDetail: Posts?
    var blackList: [BlockList] = []
    @IBOutlet weak var postDetailTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pointColor
        postDetailTableView.dataSource = self
        postDetailTableView.delegate = self
        postDetailTableView.backgroundColor = .pointColor
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
    @objc func pressMore() {
        let controller = UIAlertController(title: "設定", message: nil, preferredStyle: .actionSheet)
        let alertTitle = postDetail?.appleID != UserData.shared.getUserAppleID() ? "檢舉作者並加入黑名單" : "刪除文章"
        let addBlackListAction = UIAlertAction(title: alertTitle, style: .destructive) { action in
            if self.postDetail?.appleID != UserData.shared.getUserAppleID() {
                self.addIntoBlackList()
            } else {
                // 刪除 storge 上的照片 10/12 以前的 firestore 沒有imageName紀錄
                if let imageNameForStorage = self.postDetail?.imageNameForStorage {
                    let storageRef = Storage.storage().reference().child("images")
                    let desertRef = storageRef.child(imageNameForStorage)
                    desertRef.delete { error in
                      if let error = error {
                        print("Firebase storage cannot delete image")
                      } else {
                        print("Storage image successfully removed!")
                      }
                    }
                }
                // 刪除 firestore 中 posts 的文章
                let db = FirebaseManager.shared.db
                guard let documentID = self.postDetail?.id else { return print("not found documentID in postDetail") }
                db.collection("posts").document(documentID).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
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
        if let imageCount = postDetail?.image?.count {
            return 2
        } else {
            return 1
        }
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
                cell.postImageView.kf.setImage(with: URL(string: image), placeholder: UIImage(named: "LiFrame_Logo_06"))
                return cell
            }
        }
        return UITableViewCell()
    }
    func addIntoBlackList() {
        if let blockUserAppleID = self.postDetail?.appleID,
           let userName = self.postDetail?.name {
            let wannaBlockUser = BlockList(blockedName: userName, blockedAppleID: blockUserAppleID)
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
            FirebaseManager().updateBlockListForFirebase(key: "blacklist", value: blackListDictArray)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
