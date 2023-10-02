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
           let blackList = userDefaults.dictionary(forKey: "blackList"),
           let documentID = userDefaults.string(forKey: "documentID") {
            if let userEmail = userData["email"] as? String,
               let userFullName = userData["fullName"] as? String,
               let ID = userID["appleID"] as? String {
                if let blackListName = blackList["blockedName"] as? String,
                   let blackListAppleID = blackList["blockedAppleID"] as? String {
                    return Users(name: userFullName, email: userEmail, id: ID, documentID: documentID, blackList: [BlackList(blockedName: blackListName, blockedAppleID: blackListAppleID)])
                } else {
                    return Users(name: userFullName, email: userEmail, id: ID, documentID: documentID)
                }
            }
        }
        return nil
    }
    func getUserDataFromFirebase(completion: @escaping (Users?) -> Void) {
        var blackLists = [BlackList]()
        let db = FirebaseManager.shared.db
        guard let appleIDFromUserDefault = UserData.shared.userDataFromUserDefault?.id else {
            completion(nil)
            print("UserDefault apple doesn't exist")
            return
        }
        db.collection("users").document(appleIDFromUserDefault).getDocument() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(nil)
                return
            } else {
                guard let querySnapshot = querySnapshot?.data() else {
                    completion(nil)
                    return
                }
                if let appleID = querySnapshot["appleID"] as? String,
                   let email = querySnapshot["email"] as? String,
                   let name = querySnapshot["fullName"] as? String,
                   let blackList = querySnapshot["blacklist"] as? [[String: Any]] {
                    for list in blackList {
                        guard let blockedID = list["blockedAppleID"] as? String,
                              let blockedName = list["blockedName"] as? String else {
                            completion(nil)
                            return
                        }
                        let blackList = BlackList(blockedName: blockedName, blockedAppleID: blockedID)
                        blackLists.append(blackList)
                    }
                    let userData = Users(name: name, email: email, id: appleID, documentID: appleID, blackList: blackLists)
                    completion(userData) // 在获取数据后调用闭包，传递 Users 对象
                } else {
                    completion(nil)
                }
            }
        }
    }
    private init() {}
}
