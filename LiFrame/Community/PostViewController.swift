//
//  PostViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/17.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class PostViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView! {
        didSet {
            contentTextView.layer.borderWidth = 1
            contentTextView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    @IBOutlet weak var tapButtonOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.hidesBackButton = true
        title = "Post"
    }
    // 點空白處收鍵盤
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
           view.endEditing(true)
       }
    @IBAction func tapButton(_ sender: Any) {
        guard let titleText = titleTextField.text,
              let categoryText = categoryTextField.text,
              let contentText = contentTextView.text else { return }
        if titleText != "", categoryText != "", contentText != "" {
            addData(title: titleText, content: contentText, category: categoryText)
            navigationController?.popViewController(animated: true)
        } else {
            showAlert()
        }
    }
    func showAlert() {
        // 建立一個提示框
         let alertController = UIAlertController(
             title: "提示",
             message: "資料尚未輸入完成",
             preferredStyle: .alert)

         // 建立[確認]按鈕
         let okAction = UIAlertAction(
             title: "確認",
             style: .default,
             handler: {
             (action: UIAlertAction!) -> Void in
               // 可以加動作
         })
         alertController.addAction(okAction)

         // 顯示提示框
        self.present(
           alertController,
           animated: true,
           completion: nil)
    }
    func addData(title: String, content: String, category: String) {
    let db = Manager.shared.db
    let posts = db.collection("posts")
    let document = posts.document()
    let data: [String: Any] = [ "author": [
    "email": "wayne@school.appworks.tw", "id": "waynechen323",
    "name": "AKA小安老師"
    ],
    "title": "\(title)",
    "content": "\(content)", "createdTime": Date().timeIntervalSince1970,
    "id": document.documentID,
    "category": "\(category)"
    ]
    document.setData(data)

    }
}
