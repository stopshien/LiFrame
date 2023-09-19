//
//  City.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/19.
//

import Foundation
import UIKit

struct Cities: Codable {
    let cities: [City]
}

struct City: Codable {
    let name: String
    let latitudinal: String
    let longitudinal: String
}
