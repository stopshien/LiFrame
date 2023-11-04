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
        LiFrame應用程式用戶終端許可協議（EULA）

        1. 重要事項： 在使用LiFrame（以下簡稱「本應用」）的發文功能之前，請仔細閱讀以下條款。點擊“同意”或類似按鈕或以任何方式使用該功能，即表示您確認您已閱讀、理解並同意受本協議的約束。

        2. 授權範圍： 本應用的開發者授予您一個非獨家的、不可轉讓的、有限的許可，以便在您的iOS設備上使用本應用的發文功能。此許可僅供個人非商業用途使用。
        3. 用戶內容： 您可以透過本應用發布、分享和傳播文字、圖片或其他材料（以下簡稱「用戶內容」）。您保證您擁有或已獲得必要的許可或授權來發布用戶內容，並不侵犯或違反任何第三方的版權、商標、隱私權或其他個人或專有權利。
        4. 內容責任： 您獨立承擔所有您通過本應用發布或以其他方式傳播的用戶內容的責任。本應用的開發者不對用戶內容進行審查並且明確拒絕承擔任何與用戶內容相關的責任。
        5. 版權與權利讓渡： 您在此授予本應用的開發者非獨家、全球性的、免版稅的、可轉讓的授權，以使用、複製、修改、創作衍生作品、分發、公開展示及執行用戶內容，僅限於為提供和促進本應用所提供的服務而需要的範圍。
        6. 內容移除： 本應用的開發者有權（但無義務）根據自己的判斷刪除或禁止存取任何用戶內容，特別是那些涉嫌侵權、違法或違反本協議條款的內容。
        7. 隱私： 關於您使用本應用的發文功能所提供或生成的數據的處理，將遵循本應用的隱私政策。通過使用發文功能，您同意您的用戶內容可以根據隱私政策被收集和使用。
        8. 遵守法律： 您同意在使用本應用的發文功能時，將遵守所有適用的法律和法規。
        9. 用戶行為準則： 使用本應用發文功能時，您同意遵守以下行為準則：

        - 不得發布或傳播任何辱罵性、誹謗性、仇恨性、暴力性、歧視性、色情性或任何形式的非法內容。
        - 不得發布或傳播侵犯他人版權、商標、專利、商業秘密、隱私權或其他知識產權或所有權的內容。
        - 不得發布虛假信息或任何形式的誤導性內容。
        - 不得傳播病毒、木馬、蠕蟲或任何其他可能破壞、干擾、秘密截取或挪用任何系統、數據或個人信息的惡意軟件。
        - 不得從事任何可能干擾本應用功能、負荷超出合理需求的行為或未經授權訪問、干擾、損害或擾亂任何與本應用相關的服務器、網絡或通過本應用存取的其他網絡。
        10. 違反用戶行為準則的後果： 如果您違反上述行為準則，本應用的開發者有權採取一切必要的措施，包括但不限於移除內容、暫停或終止您的帳戶使用權限、報告給執法機關以及採取法律行動。

        11. 免責聲明： 本應用及其開發者不對您或任何第三方因使用或依賴於通過本應用傳播的任何用戶內容而可能產生的任何形式的損失或損害承擔責任。儘管有前述規定，本應用開發者保留對用戶內容進行監控的權利，但並無義務這樣做。

        12. 協議的修改與變更： 本應用的開發者保留隨時修改本協議條款的權利。您繼續使用本應用將視為您接受該等修改。

        點擊“我同意”即表示您確認您已經閱讀、理解並同意遵守本協議的所有條款和條件，包括隨時更新的隱私政策以及本條款中的用戶行為準則。

        如果您不同意本協議的任何條款，您應該停止使用本應用的發文功能。


        """
    }

}
