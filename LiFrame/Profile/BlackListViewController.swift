//
//  ProfileViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/30.
//

import UIKit

class BlackListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var blackListFromUserData = [BlackList]()
    let blackListTableView: UITableView = {
        let tableView = UITableView()
        let fullScreen = UIScreen.main.bounds
        tableView.frame = CGRect(x: 0, y: 0, width: fullScreen.width, height: fullScreen.height)
        tableView.backgroundColor = .red
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(blackListTableView)
        blackListTableView.delegate = self
        blackListTableView.dataSource = self
        blackListTableView.register(BlackListTableViewCell.self, forCellReuseIdentifier: "BlackListTableViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        if let blackList = UserData.shared.userDataFromUserDefault?.blackList {
            blackListFromUserData = blackList
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blackListFromUserData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = blackListTableView.dequeueReusableCell(withIdentifier: "BlackListTableViewCell", for: indexPath) as? BlackListTableViewCell else { return BlackListTableViewCell() }
        cell.blackName.text = "label"
        return cell
    }
}
