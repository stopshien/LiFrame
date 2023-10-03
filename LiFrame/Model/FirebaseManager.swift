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
    func pushToFirebaseForUser(documentData: [String: Any], appleID: String) {
        let users = db.collection("users")
        let document = users.document(appleID)
        document.getDocument { documentSnapshot, error in
            guard let documentSnapshot = documentSnapshot, documentSnapshot.exists else {
                document.setData(documentData)
                return
            }
        }
    }
    func editUserDataForFirebase(key: String, value: String) {
        let users = db.collection("users")
        if let userAppleID = UserData.shared.getUserAppleID() {
            let document = users.document(userAppleID)
            let data = [key: value]
            document.updateData(data)
        }
    }
    func updateBlackListForFirebase(key: String, value: [[String: Any]]) {
        let users = db.collection("users")
        if let userAppleID = UserData.shared.getUserAppleID() {
            let document = users.document(userAppleID)
            let data = [key: value]
            document.updateData(data)
        }
    }
}
