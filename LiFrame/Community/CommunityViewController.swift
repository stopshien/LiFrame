//
//  CommunityViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/17.
//

import UIKit
import FirebaseFirestore
import CMHUD
import AuthenticationServices

class CommunityViewController: UIViewController {
    var postsArray: [Posts] = [] {
        didSet {
            communityTableView.reloadData()
        }
    }
    let dformatter = DateFormatter()
    @IBOutlet weak var communityTableView: UITableView!
    let addPostButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .mainLabelColor
        let configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30))
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
//        UserDefaults.standard.removeObject(forKey: "eulaState")
        view.backgroundColor = .pointColor
        communityTableView.dataSource = self
        communityTableView.delegate = self
        view.addSubview(addPostButton)
        setButtonUI()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: self, action: #selector(tappedProfile))

        dformatter.dateFormat = "yyyy.MM.dd HH:mm"
        NotificationCenter.default.addObserver(self, selector: #selector(updatePostData), name: Notification.Name("updatePostData"), object: nil)
        communityTableView.addRefreshHeader(refreshingBlock: { [weak self] in
            self?.updatePost()
            self?.headerLoader()
        })
        addPostButton.addTarget(self, action: #selector(tappedPostButton), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(tappedPostButton), name: Notification.Name("loginView"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        updatePost()
    }
    func headerLoader() {
        communityTableView.endHeaderRefreshing()
    }
    @objc func updatePostData() {
        guard let image = UIImage(systemName: "door.left.hand.open") else { return }
        CMHUD.show(image: image, in: view, identifier: "Log in", imageSize: CGSize(width: 100, height: 100))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            CMHUD.hide(from: self.view)
            self.updatePost()
        }
    }
    func updatePost() {
        var blockLists = [BlockList(blockedName: "", blockedAppleID: "")]
        UserData.shared.getUserDataFromFirebase { user in
            if let user = user, !user.blackList.isEmpty {
                blockLists = user.blackList
            }
            CMHUD.loading(in: self.view)
            self.postsArray = []
            let db = FirebaseManager.shared.db
            let blockedAppleIDs = blockLists.map { $0.blockedAppleID }
            print(blockLists, blockedAppleIDs)
            db.collection("posts").whereField("author.id", notIn: blockedAppleIDs).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if let title = document.data()["title"] as? String,
                           let author = document.data()["author"] as? [String: String],
                           let content = document.data()["content"] as? String,
                           let category = document.data()["category"] as? String,
                           let time = document.data()["createdTime"] as? Double,
                           let documentID = document.data()["id"] as? String {
                            let image = document.data()["photoURL"] as? String
                            let timeInterval: TimeInterval = TimeInterval(time)
                            let date = Date(timeIntervalSince1970: timeInterval)
                            guard let name = author["name"],
                                  let appleID = author["id"] else { return }
                            if let imageNameForStorage = document.data()["imageNameForStorage"] as? String {
                                let post = Posts(appleID: appleID, title: title, name: "\(name)", createdTime: "\(self.dformatter.string(from: date))", category: category, content: content, image: image, id: documentID, imageNameForStorage: imageNameForStorage)
                                self.postsArray.insert(post, at: 0)
                            } else {
                                let post = Posts(appleID: appleID, title: title, name: "\(name)", createdTime: "\(self.dformatter.string(from: date))", category: category, content: content, image: image, id: documentID, imageNameForStorage: nil)
                                self.postsArray.insert(post, at: 0)
                            }
                        }
                    }
                }
                self.postsArray.sort { $0.createdTime > $1.createdTime }
                CMHUD.hide(from: self.view)
            }
        }
        // 判斷使否已經登入,userData 都存在 UserData 中
        if UserData.shared.getUserAppleID() != nil {
            navigationItem.rightBarButtonItem?.isHidden = false
        } else {
            navigationItem.rightBarButtonItem?.isHidden = true
        }
    }
    @objc func tappedProfile() {
        let controller = UIAlertController(title: "個人設定", message: nil, preferredStyle: .actionSheet)
        let watchBlockListAction = UIAlertAction(title: "查看黑名單", style: .default) { action in
            let blockListVC = BlockListViewController()
            self.navigationController?.pushViewController(blockListVC, animated: true)
        }
        let logOutAction = UIAlertAction(title: "登出", style: .default) { action in
            UserDefaults.standard.removeObject(forKey: "UserAppleID")
            self.updatePost()
            guard let image = UIImage(systemName: "door.left.hand.closed") else { return }
            CMHUD.show(image: image, in: self.view, identifier: "Log Out", imageSize: CGSize(width: 80, height: 80))
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                CMHUD.hide(from: self.view, delay: 2)
            }
        }
        controller.addAction(watchBlockListAction)
        controller.addAction(logOutAction)
        let removeAction = UIAlertAction(title: "刪除帳號", style: .default) { action in
            self.checkDeleteAlert()
        }
        controller.addAction(removeAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true)
    }
    func checkDeleteAlert() {
        let alertController = UIAlertController(
            title: "確認是否刪除此帳號",
            message: "請留意帳號刪除後將遺失所有資料",
            preferredStyle: .alert)
        // 建立[確認]按鈕
        let okAction = UIAlertAction(
            title: "刪除",
            style: .default,
            handler: {
            (action: UIAlertAction!) -> Void in
                // 刪除 firebase 黑名單
                FirebaseManager().updateBlockListForFirebase(key: "blacklist", value: [])
                UserDefaults.standard.removeObject(forKey: "UserAppleID")
                self.updatePost()
                guard let image = UIImage(systemName: "door.left.hand.closed") else { return }
                CMHUD.show(image: image, in: self.view, identifier: "Log Out", imageSize: CGSize(width: 80, height: 80))
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    CMHUD.hide(from: self.view)
                }
                UserData.shared.eulaCheck = false
                UserDefaults.standard.removeObject(forKey: "eulaState")
        })
       let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
       alertController.addAction(okAction)
       alertController.addAction(cancelAction)
        // 顯示提示框
       self.present(
          alertController,
          animated: true,
          completion: nil)
    }
    @objc func tappedPostButton() {
        // 判斷使否已經登入,userData 都存在 UserData 中
        if UserData.shared.eulaCheck {
            if let userID = UserData.shared.getUserAppleID() {
                checkCredentialState(withUserID: userID)
            } else {
                checkCredentialState(withUserID: "")
                communityTableView.reloadData()
            }
        } else {
            let eulaVC = EULAViewController()
            present(eulaVC, animated: true)
        }
    }
    func setButtonUI() {
        NSLayoutConstraint.activate([
            addPostButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addPostButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            addPostButton.widthAnchor.constraint(equalToConstant: 50),
            addPostButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        addPostButton.layer.cornerRadius = 25
        addPostButton.clipsToBounds = true
    }
    func checkCredentialState(withUserID userID: String) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userID) { (credentialState, error) in
            switch credentialState {
            case .authorized:
                DispatchQueue.main.async {
                    // 登入狀態，切換到 po 文頁面
                    guard let postVC = self.storyboard?.instantiateViewController(identifier: "PostViewController") else { return }
                    self.navigationController?.pushViewController(postVC, animated: true)
                }
                print("Login")
            case .revoked:
                DispatchQueue.main.async {
                    // 尚未登入，顯示登入畫面
                    let signInVC = SignInViewController.shared
                    if let sheetPresentationController = signInVC.sheetPresentationController {
                        sheetPresentationController.detents = [.custom(resolver: { context in
                            context.maximumDetentValue * 0.2
                        })]
                        sheetPresentationController.preferredCornerRadius = 50
                        self.present(signInVC, animated: true)
                    }
                }
                print("not login")
            case .notFound:
                DispatchQueue.main.async {
                    let signInVC = SignInViewController.shared
                    if let sheetPresentationController = signInVC.sheetPresentationController {
                        sheetPresentationController.detents = [.custom(resolver: { context in
                            context.maximumDetentValue * 0.2
                        })]
                        sheetPresentationController.preferredCornerRadius = 50
                        self.present(signInVC, animated: true)
                    }
                }
                print("not found")
                // 無此用戶
            default:
                break
            }
        }
    }
}
extension CommunityViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = communityTableView.dequeueReusableCell(withIdentifier: "CommunityTableViewCell", for: indexPath) as? CommunityTableViewCell else { return CommunityTableViewCell() }
        cell.titleLabel.text = "【 \(postsArray[indexPath.row].category) 】\(postsArray[indexPath.row].title)"
        cell.createTimeLabel.text = postsArray[indexPath.row].createdTime
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(identifier: "PostDetailViewController") as? PostDetailViewController else { return }
        detailVC.postDetail = postsArray[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
