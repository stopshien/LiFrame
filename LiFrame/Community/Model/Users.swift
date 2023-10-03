//
//  User.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/28.
//

import Foundation
struct Users {
    let name: String
    let email: String
    let id: String
    let documentID: String
    var blackList: [BlackList] = []
}

struct BlackList: Equatable {
    let blockedName: String
    let blockedAppleID: String

    static func == (lhs: BlackList, rhs: BlackList) -> Bool {
        return lhs.blockedName == rhs.blockedName && lhs.blockedAppleID == rhs.blockedAppleID
    }
}
