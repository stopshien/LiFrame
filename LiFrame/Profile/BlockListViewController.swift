//
//  ProfileViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/30.
//

import UIKit
import FirebaseStorage

class BlockListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var blackListFromUserData = [BlockList]()
    let blackListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .pointColor
        tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height)
        return tableView
    }()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(blackListTableView)
        blackListTableView.delegate = self
        blackListTableView.dataSource = self
        blackListTableView.register(BlackListTableViewCell.self, forCellReuseIdentifier: "BlackListTableViewCell")
        blackListTableView.allowsSelection = false
    }
    override func viewWillAppear(_ animated: Bool) {
        getBlockList()
        self.blackListTableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        let blackListDictArray = self.blackListFromUserData.map { blackList -> [String: Any] in
            return [
                "blockedName": blackList.blockedName,
                "blockedAppleID": blackList.blockedAppleID
            ]
        }
        FirebaseManager().updateBlockListForFirebase(key: "blacklist", value: blackListDictArray)
    }
    func getBlockList() {
        UserData.shared.getUserDataFromFirebase { user in
            if let user = user {
                self.blackListFromUserData = user.blackList
            }
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "黑名單"
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blackListFromUserData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = blackListTableView.dequeueReusableCell(withIdentifier: "BlackListTableViewCell", for: indexPath) as? BlackListTableViewCell else { return BlackListTableViewCell() }
        cell.blackName.text = blackListFromUserData[indexPath.row].blockedName
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        self.blackListFromUserData.remove(at: indexPath.row)
        self.blackListTableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
}
