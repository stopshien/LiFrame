//
//  LiFrameUnitTests.swift
//  LiFrameUnitTests
//
//  Created by TingFeng Shen on 2023/10/22.
//

import XCTest
@testable import LiFrame

// 測試之後更改本地 json 檔案內容或是名稱紀錄地區的 array 能不能順利拿到資料。
final class MapViewUnitTest: XCTestCase {
    func testGetCitiesFromAsset() {
        let mapVC = MapViewController()
        let citiesDataFromAssetName = "cities"
        mapVC.citiesToMap(citisNameFromAsset: citiesDataFromAssetName)
        XCTAssertNotEqual(mapVC.citiesArray.count, 0)
    }
}

// 測試是儲存 Lut 檔是否有成功，並且在測試完後恢復原本儲存的 Lut 檔。
final class AddLutTest: XCTestCase {
    func testLutSave() {
        let lutManager = LutManager.shared
        let editVC = EditViewController()

        let originLut = lutManager.loadLuts()
        let testLut = Lut(name: "test2", bright: 0.5, contrast: 1, saturation: 1)
        editVC.saveLutToUserDefeault(testLut)
        let newLut = lutManager.loadLuts()
        guard let originLut = originLut, var newLut = newLut else {
            guard let newLut = newLut else { return }
            XCTAssertEqual(1, newLut.count)
            return
        }
        XCTAssertEqual(originLut.count + 1, newLut.count)
        let lastOfNewLut = newLut.count
        newLut.remove(at: lastOfNewLut - 1)
        var recoverLut = [[String: Any]]()
        for lut in newLut {
            let lutData: [String: Any] = [
                "name": lut.name,
                "brightness": lut.bright,
                "contrast": lut.contrast,
                "saturation": lut.saturation
            ]
            recoverLut.append(lutData)
        }
        UserDefaults.standard.set(recoverLut, forKey: "luts")
    }
}

final class PostDataToFirebaseTest: XCTestCase {
    func testPostDataToFirebase() {
        var ID = ""
        let postVC = PostViewController()
        postVC.postDataToFirebase(collection: "unitTest", title: "test", content: "test", category: "test", image: nil)
        let db = FirebaseManager.shared.db
            db.collection("unitTest").getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        if let documentID = document.data()["lut"] as? String {
                            ID = documentID
                            XCTAssertNotEqual(ID, "")
                        }
                    }
                }
            }
    }
}
