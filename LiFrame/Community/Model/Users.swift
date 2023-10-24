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
    var blackList: [BlockList] = []
}

struct BlockList: Equatable {
    let blockedName: String
    let blockedAppleID: String

    static func == (lhs: BlockList, rhs: BlockList) -> Bool {
        return lhs.blockedName == rhs.blockedName && lhs.blockedAppleID == rhs.blockedAppleID
    }
}
