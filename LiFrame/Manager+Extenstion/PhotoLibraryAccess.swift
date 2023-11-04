//
//  PhotoLibraryAccess.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/11/4.
//

import Foundation
import Photos
import UIKit
protocol PhotoLibraryPermissionDelegate: AnyObject {
    func onAuthorizationStatusAuthorized()
    func onAuthorizationStatusDenied()
    func onAuthorizationStatusRestricted()
}

extension PhotoLibraryPermissionDelegate where Self: UIViewController {

    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    self.handleAuthorizationStatus(newStatus)
                }
            }
        case .restricted, .denied, .authorized, .limited:
            DispatchQueue.main.async {
                self.handleAuthorizationStatus(status)
            }
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }

    private func handleAuthorizationStatus(_ status: PHAuthorizationStatus) {
        switch status {
        case .authorized, .limited:
            self.onAuthorizationStatusAuthorized()
        case .denied:
            self.onAuthorizationStatusDenied()
            self.dismiss(animated: true)
            presentPhotoLibrarySettingsAlert()
        case .restricted:
            self.onAuthorizationStatusRestricted()
            presentPhotoLibrarySettingsAlert()
        case .notDetermined:
            // This case should not occur because we handle it in checkPhotoLibraryPermission
            break
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }

    func presentPhotoLibrarySettingsAlert() {
        let alert = UIAlertController(
            title: "未授權相簿權限",
            message: "請前往設定 > 隱私權與安全性 > 照片，允許此應用訪問您的照片。",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "設定", style: .default, handler: { _ in
            self.dismiss(animated: true)
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        self.present(alert, animated: true)
    }
}
