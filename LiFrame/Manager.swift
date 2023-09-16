//
//  Manager.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/15.
//

import Foundation
class Manager {
    static let shared = Manager()
    private init() {}
    // 讀取 Lut 對象
    func loadLuts() -> [Lut]? {
        let userDefaults = UserDefaults.standard
        if let savedLuts = userDefaults.array(forKey: "luts") as? [[String: Any]] {
            // compactMap 不處理 nil 值得 map
            return savedLuts.compactMap { lutData in
                guard let name = lutData["name"] as? String,
                      let brightness = lutData["brightness"] as? Float,
                      let contrast = lutData["contrast"] as? Float else {
                    return nil
                }
                return Lut(name: name, bright: brightness, contrast: contrast)
            }
        }
        return []
    }
}
