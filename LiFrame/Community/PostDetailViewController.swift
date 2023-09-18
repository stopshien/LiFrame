//
//  PostDetailViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/17.
//

import UIKit

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
        1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = postDetailTableView.dequeueReusableCell(withIdentifier: "PostDetailTableViewCell", for: indexPath) as? PostDetailTableViewCell,
        let postDetail = postDetail else { return PostDetailTableViewCell() }
        cell.titleLabel.text = postDetail.title
        cell.createTimeLabel.text = postDetail.createdTime
        cell.contentLabel.text = postDetail.content
        cell.posterNameLabel.text = postDetail.name
        return cell
    }
}
