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
}
