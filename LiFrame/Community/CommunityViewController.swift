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
        didSet{
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
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(tappedPostButton), for: .touchUpInside)
        let configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30))
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        communityTableView.dataSource = self
        communityTableView.delegate = self
        view.addSubview(addPostButton)
        setButtonUI()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(tapLogOut))
        dformatter.dateFormat = "yyyy.MM.dd HH:mm"
    }
    override func viewWillAppear(_ animated: Bool) {
        CMHUD.loading(in: view)
        postsArray = []
        var blackLists = [""]
        let db = FirebaseManager.shared.db
        if let list = UserData.shared.userDataFromUserDefault?.blackList,
        list != [] {
            blackLists = list
        }
        db.collection("posts").whereField("author.id", notIn: blackLists).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if let title = document.data()["title"] as? String,
                       let author = document.data()["author"] as? [String: String],
                       let content = document.data()["content"] as? String,
                       let category = document.data()["category"] as? String,
                       let time = document.data()["createdTime"] as? Double {
                        let image = document.data()["photoURL"] as? String
                        let timeInterval: TimeInterval = TimeInterval(time)
                        let date = Date(timeIntervalSince1970: timeInterval)
                        guard let name = author["name"],
                              let appleID = author["id"] else { return }
                        let post = Posts(appleID: appleID, title: title, name: "\(name)", createdTime: "\(self.dformatter.string(from: date))", category: category, content: content, image: image)
                        self.postsArray.insert(post, at: 0)
                    }
                }
            }
            self.postsArray.sort { $0.createdTime > $1.createdTime }
            CMHUD.hide(from: self.view)
        }
    }
    @objc func tapLogOut() {
        UserDefaults.standard.removeObject(forKey: "UserAppleID")
    }
    @objc func tappedPostButton() {
        // 判斷使否已經登入,userData 都存在 UserData 中
            if let userID = UserData.shared.userDataFromUserDefault?.id {
                checkCredentialState(withUserID: userID)
            } else {
                checkCredentialState(withUserID: "")
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
                    self.navigationController?.pushViewController(SignInViewController.shared, animated: true)
                }
                print("not login")
            case .notFound:
                DispatchQueue.main.async {
                    // 尚未登入，顯示登入畫面
                    self.navigationController?.pushViewController(SignInViewController.shared, animated: true)
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
