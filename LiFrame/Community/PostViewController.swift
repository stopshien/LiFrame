//
//  PostViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/17.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import Kingfisher
import CMHUD

class PostViewController: UIViewController {
    let semaphore = DispatchSemaphore(value: 0)
    private var selectPhoto = false // 判定是否有選擇照片
    var postImage: UIImage?
    @IBOutlet weak var imageButtonOutlet: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var tapButtonOutlet: UIButton! {
        didSet {
            tapButtonOutlet.backgroundColor = .gray
            tapButtonOutlet.setTitleColor(.white, for: .normal)
            tapButtonOutlet.tintColor = .white
            tapButtonOutlet.clipsToBounds = true
            tapButtonOutlet.layer.cornerRadius = 10
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // 點空白處收鍵盤
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
           view.endEditing(true)
       }
    @IBAction func addImageButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func tapButton(_ sender: Any) {
        guard let titleText = titleTextField.text,
              let categoryText = categoryTextField.text,
              let contentText = contentTextView.text else { return }
        if titleText != "", categoryText != "", contentText != "",
        let image = postImage {
            addData(title: titleText, content: contentText, category: categoryText, image: image)
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
    func addData(title: String, content: String, category: String, image: UIImage?) {
        CMHUD.loading(in: view)
        let db = FirebaseManager.shared.db
        let posts = db.collection("posts")
        let document = posts.document()
        // 上傳照片至 Firebase Cloud Storage
        let storageRef = Storage.storage().reference().child("images")
        let imageRef = storageRef.child(UUID().uuidString + ".jpg")
        if let image = image,
           let imageData = image.jpegData(compressionQuality: 0.8) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                } else {
                    imageRef.downloadURL { (url, error) in
                        if let downloadURL = url?.absoluteString {
                            guard let idFromApple = UserData.shared.getUserAppleID() else { return }
                            let userNameFromApple = UserData.shared.userAppleName
                            let emailFromApple = UserData.shared.userAppleEmail
                            let data: [String: Any] = [
                                "author": [
                                    "email": emailFromApple,
                                    "id": idFromApple,
                                    "name": userNameFromApple
                                ],
                                "title": title,
                                "content": content,
                                "createdTime": Date().timeIntervalSince1970,
                                "id": document.documentID,
                                "category": category,
                                "photoURL": downloadURL // 存儲照片的下載 URL
                            ]
                            // 儲存資料至 Firestore
                            document.setData(data) { (error) in
                                if let error = error {
                                    print("Error adding document: \(error.localizedDescription)")
                                } else {
                                    self.navigationController?.popViewController(animated: true)
                                    CMHUD.hide(from: self.view)
                                    print("Document added successfully!")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
extension PostViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectPhoto = true
        let image = info[.originalImage] as? UIImage
        imageButtonOutlet.setImage(image, for: .normal)
        postImage = image
        imageButtonOutlet.imageView?.contentMode = .scaleAspectFit
        dismiss(animated: true, completion: nil)
    }
}
