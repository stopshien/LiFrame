//
//  UserData.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/29.
//

import Foundation
class UserData {
    static let shared = UserData()
    var userDataFromUserDefault: Users? {
        let userDefaults = UserDefaults.standard
        if let userData = userDefaults.dictionary(forKey: "UserDataFromApple"),
           let userID = userDefaults.dictionary(forKey: "UserAppleID"),
           let documentID = userDefaults.string(forKey: "documentID") {
            if let userEmail = userData["email"] as? String,
               let userFullName = userData["fullName"] as? String,
               let ID = userID["user"] as? String {
                return Users(name: userFullName, email: userEmail, id: ID, documentID: documentID)
            }
        }
        return nil
    }
    private init() {

    }
}
