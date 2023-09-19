//
//  Whether.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/19.
//

import Foundation

// MARK: - Whether
struct Whether: Codable {
    let success: String
    let result: Result
    let records: Records
}

// MARK: - Records
struct Records: Codable {
    let dataid, note: String
    let locations: Locations
}

// MARK: - Locations
struct Locations: Codable {
    let location: [Location]
}

// MARK: - Location
struct Location: Codable {
    let time: [Time]
    let countyName: String

    enum CodingKeys: String, CodingKey {
        case time
        case countyName = "CountyName"
    }
}

// MARK: - Time
struct Time: Codable {
    let date, moonRiseTime, moonRiseAZ, moonTransitTime: String
    let moonTransitAlt, moonSetTime, moonSetAZ: String

    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case moonRiseTime = "MoonRiseTime"
        case moonRiseAZ = "MoonRiseAZ"
        case moonTransitTime = "MoonTransitTime"
        case moonTransitAlt = "MoonTransitAlt"
        case moonSetTime = "MoonSetTime"
        case moonSetAZ = "MoonSetAZ"
    }
}

// MARK: - Result
struct Result: Codable {
    let resourceID: String
    let fields: [Field]

    enum CodingKeys: String, CodingKey {
        case resourceID = "resource_id"
        case fields
    }
}

// MARK: - Field
struct Field: Codable {
    let id, type: String
}
