//
//  User.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/28.
//

import Foundation
import FirebaseFirestore
struct Users {
    let name: String
    let email: String
    let id: String
    let documentID: String
    var blackList: [String] = []
}
