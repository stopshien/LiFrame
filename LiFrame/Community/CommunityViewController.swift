//
//  CommunityViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/17.
//

import UIKit
import FirebaseFirestore

class CommunityViewController: UIViewController {
    var postsArray: [Posts] = [] {
        didSet{
            communityTableView.reloadData()
        }
    }
    @IBOutlet weak var communityTableView: UITableView!
    let addPostButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
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
    }
    override func viewWillAppear(_ animated: Bool) {
        postsArray = []
        let db = FirebaseManager.shared.db
        db.collection("posts").order(by: "createdTime").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if let title = document.data()["title"] as? String,
                       let author = document.data()["author"] as? [String: String],
                       let content = document.data()["content"] as? String,
                       let category = document.data()["category"] as? String,
                       let time = document.data()["createdTime"] as? Double
                    {
                        let image = document.data()["photoURL"] as? String
                        let timeInterval: TimeInterval = TimeInterval(time)
                        let date = Date(timeIntervalSince1970: timeInterval)
                        let dformatter = DateFormatter()
                        dformatter.dateFormat = "yyyy.MM.dd HH:mm"
                        guard let name = author["name"] else { return }
                        let post = Posts(title: title, name: "\(name)", createdTime: "\(dformatter.string(from: date))", category: category, content: content, image: image)
                        self.postsArray.insert(post, at: 0)
                    }
                }
            }
        }
    }
    @objc func tappedButton() {
        guard let postVC = storyboard?.instantiateViewController(identifier: "PostViewController") else { return }
        navigationController?.pushViewController(postVC, animated: true)
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
        cell.titleLabel.text = postsArray[indexPath.row].title
        cell.createTimeLabel.text = postsArray[indexPath.row].createdTime
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(identifier: "PostDetailViewController") as? PostDetailViewController else { return }
        detailVC.postDetail = postsArray[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
