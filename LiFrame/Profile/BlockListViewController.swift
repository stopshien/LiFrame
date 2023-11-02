//
//  ProfileViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/30.
//

import UIKit
import FirebaseStorage

class BlockListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var blockListFromUserData = [BlockList]()
    let blockListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .pointColor
        tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height)
        return tableView
    }()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(blockListTableView)
        blockListTableView.delegate = self
        blockListTableView.dataSource = self
        blockListTableView.register(BlockListTableViewCell.self, forCellReuseIdentifier: "BlockListTableViewCell")
        blockListTableView.allowsSelection = false
    }
    override func viewWillAppear(_ animated: Bool) {
        getBlockList()
    }
    override func viewWillDisappear(_ animated: Bool) {
        let blackListDictArray = self.blockListFromUserData.map { blackList -> [String: Any] in
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
                self.blockListFromUserData = user.blackList
                print(self.blockListFromUserData.count,"===")
                self.blockListTableView.reloadData()
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
        return blockListFromUserData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = blockListTableView.dequeueReusableCell(withIdentifier: "BlockListTableViewCell", for: indexPath) as? BlockListTableViewCell else { return BlockListTableViewCell() }
        cell.blockName.text = blockListFromUserData[indexPath.row].blockedName
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        self.blockListFromUserData.remove(at: indexPath.row)
        self.blockListTableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
}
