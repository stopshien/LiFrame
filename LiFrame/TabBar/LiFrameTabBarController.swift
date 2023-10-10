//
//  TabBarViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/10/7.
//

import UIKit

class LiFrameTabBarController: UITabBarController, UITabBarControllerDelegate {

    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        // 設定代理
        self.delegate = self
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // 在選項卡切換時觸發觸覺回饋
        feedbackGenerator.impactOccurred()
    }
}
