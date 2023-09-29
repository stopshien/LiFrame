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
           let userID = userDefaults.dictionary(forKey: "UserAppleID") {
            if let userEmail = userData["email"] as? String,
               let ID = userID["user"] as? String,
               let userFullName = userData["fullName"] as? String {
                return Users(name: userFullName, email: userEmail, id: ID)
            }
        }
        return nil
    }
    private init() {

    }
}
