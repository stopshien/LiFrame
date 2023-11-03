//
//  EULAViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/11/3.
//

import UIKit

class EULAViewController: UIViewController {

    let eulaTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .mainColor
        textView.textColor = .mainLabelColor
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.isEditable = false
        return textView
    }()
    let checkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("我同意", for: .normal)
        return button
    }()
    let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("暫不使用", for: .normal)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainLabelColor
        view.addSubview(eulaTextView)
        view.addSubview(checkButton)
        view.addSubview(cancelButton)
        setConstraint()
        setEULAContent()
        checkButton.addTarget(self, action: #selector(tappedAgree), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(tappedDisAgree), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    @objc func tappedAgree() {
        dismiss(animated: true)
        UserDefaults.standard.set(true, forKey: "eulaState")
        UserData.shared.eulaCheck = true
        NotificationCenter.default.post(name: NSNotification.Name("loginView"), object: nil)
    }
    @objc func tappedDisAgree() {
        dismiss(animated: true)
    }
    func setConstraint() {
        NSLayoutConstraint.activate([
            eulaTextView.topAnchor.constraint(equalTo: view.topAnchor),
            eulaTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            eulaTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            eulaTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            checkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            checkButton.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: 0),
            checkButton.topAnchor.constraint(equalTo: eulaTextView.bottomAnchor, constant: 5),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            cancelButton.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor)
        ])
    }
    func setEULAContent() {
        eulaTextView.text = """
        用戶協議同意書

        歡迎使用 LiFrame！

        在您使用 LiFrame 之前，我們需要您閱讀並同意下述的用戶協議。該協議旨在確保 LiFrame 社區的安全性與積極性，並明確我們對所有用戶的期望。

        協議內容摘要：
        - 內容標準：用戶不得上傳、分享或發布任何被視為攻擊性、令人反感或違法的內容。此類內容包括但不限於仇恨言論、淫穢、侵權或鼓勵暴力的材料。
        - 行為守則：用戶必須尊重他人，避免任何形式的騷擾、欺凌或威脅行為。
        - 內容審核：如果用戶遇到不適當的內容，我們鼓勵他們使用報告功能。我們的團隊將審核報告並採取相應措施。
        - 違規後果：違反這些標準的用戶可能會面臨包括但不限於內容移除、帳號暫停或終止等後果。

        同意聲明：
        我已閱讀並理解上述的用戶協議。我同意遵守這些規定，並認識到，如果我違反這些條款，可能會導致對我的帳號採取行動，包括帳號的終止。
        """
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
