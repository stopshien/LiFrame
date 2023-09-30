//
//  FirebaseManager.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/18.
//

import Foundation
import FirebaseFirestore
class FirebaseManager {
    static let shared = FirebaseManager()
    let db = Firestore.firestore()
    func pushToFirebaseForUser(documentData: [String: Any]) {
        var newDocumentData = documentData
        let users = db.collection("users")
        let document = users.document()
        let id = document.documentID
        newDocumentData["documentID"] = id
        document.setData(newDocumentData)
        UserDefaults.standard.set(id, forKey: "documentID")
    }
    func editUserDataForFirebase(key: String, value: String) {
        let users = db.collection("users")
        if let documentID = UserData.shared.userDataFromUserDefault?.documentID {
            let document = users.document(documentID)
            let data = [key: value]
            document.updateData(data)
        }
    }
}
