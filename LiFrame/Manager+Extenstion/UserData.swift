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
    let userDefaults = UserDefaults.standard
    // 定義一個方法來獲取 userAppleID
    func getUserAppleID() -> String? {
        if let appleID = UserDefaults.standard.object(forKey: "UserAppleID") as? [String: String],
           let ID = appleID["appleID"] {
            return ID
        } else {
            return nil
        }
    }
    var userAppleID: String? = {
        if let appleID = UserDefaults.standard.object(forKey: "UserAppleID") as? [String: String],
           let ID = appleID["appleID"] {
            return ID
        } else {
            return nil
        }
    }()

    lazy var userAppleName: String = {
        if let userData = userDefaults.dictionary(forKey: "UserDataFromApple"),
           let userName = userData["fullName"] as? String {
            return userName
        }
        return "匿名"
    }()

    lazy var userAppleEmail: String = {
        if let userData = userDefaults.dictionary(forKey: "UserDataFromApple"),
           let userEmail = userData["email"] as? String {
            return userEmail
        }
        return "未提供email"
    }()

    lazy var userDataFromUserDefault: Users? = {
        if let appleID = userAppleID {
            return Users(name: userAppleName, email: userAppleEmail, id: appleID, documentID: appleID)
        } else {
            print("User data could not be created")
            return nil
        }
    }()

    func getUserDataFromFirebase(completion: @escaping (Users?) -> Void) {
        var blockLists = [BlockList]()
        let db = FirebaseManager.shared.db
        guard let appleIDFromUserDefault = UserData.shared.getUserAppleID() else {
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
                        let blackList = BlockList(blockedName: blockedName, blockedAppleID: blockedID)
                        blockLists.append(blackList)
                    }
                    let userData = Users(name: name, email: email, id: appleID, documentID: appleID, blackList: blockLists)
                    completion(userData)
                } else {
                    completion(nil)
                }
            }
        }
    }
    func getDataFromFirebase(completion: @escaping (Users?) -> Void) {
        let db = FirebaseManager.shared.db
        guard let appleIDFromUserDefault = UserData.shared.getUserAppleID() else {
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
                   let name = querySnapshot["fullName"] as? String {
                    let userData = Users(name: name, email: email, id: appleID, documentID: appleID)
                    completion(userData)
                } else {
                    completion(nil)
                }
            }
        }
    }
    private init() {}
}
