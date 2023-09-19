//
//  APIManager.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/19.
//

import Foundation
class APIManager {
    static let shared = APIManager()
    private init() {}
    let apiKey = Bundle.main.object(forInfoDictionaryKey: "Authorization_KEY") as? String
    
}
