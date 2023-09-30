//
//  UserData.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/29.
//

import Foundation
import FirebaseFirestore
class UserData {
    static let shared = UserData()
    var userDataFromUserDefault: Users? {
        let userDefaults = UserDefaults.standard
        if let userData = userDefaults.dictionary(forKey: "UserDataFromApple"),
           let userID = userDefaults.dictionary(forKey: "UserAppleID"),
           let documentID = userDefaults.string(forKey: "documentID") {
            if let userEmail = userData["email"] as? String,
               let userFullName = userData["fullName"] as? String,
               let ID = userID["appleID"] as? String {
                if let blackList = userDefaults.array(forKey: "blackList") as? [String] {
                    return Users(name: userFullName, email: userEmail, id: ID, documentID: documentID, blackList: blackList)
                } else {
                    return Users(name: userFullName, email: userEmail, id: ID, documentID: documentID)
                }
            }
        }
        return nil
    }
    private init() {}
//    func getBlackList(completion: @escaping ([String]) -> Void) {
//        let db = FirebaseManager.shared.db
//        if let appleID = UserData.shared.userDataFromUserDefault?.id {
//            db.collection("users").document(appleID).getDocument { (snapshot, error) in
//                if let error = error {
//                    print(error.localizedDescription)
//                    completion([]) // 處理錯誤情況，返回空的黑名單
//                } else if let snapshot = snapshot,
//                    snapshot.exists,
//                    let list = snapshot.data()?["blackList"] as? [String] {
//                    completion(list) // 返回從 Firebase 獲得的黑名單
//                } else {
//                    completion([]) // 如果沒有黑名單數據，也返回空的黑名單
//                }
//            }
//        }
//    }

}
