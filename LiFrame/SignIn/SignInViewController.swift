//
//  SignInViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/27.
//

import UIKit
import AuthenticationServices

class SignInViewController: UIViewController {

    static let shared = SignInViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signInButton)
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        signInButton.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
    }
    let signInButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc func signInWithApple() {
        let signInWithAppleRequest: ASAuthorizationAppleIDRequest = ASAuthorizationAppleIDProvider().createRequest()
        signInWithAppleRequest.requestedScopes = [.fullName, .email]

        let controller: ASAuthorizationController = ASAuthorizationController(authorizationRequests: [signInWithAppleRequest])

        controller.delegate = self
        controller.presentationContextProvider = self

        controller.performRequests()
    }
}

extension SignInViewController: ASAuthorizationControllerDelegate {
    /// 授權成功
       /// - Parameters:
       ///   - controller: _
    ///   - authorization: _
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print("user: \(appleIDCredential.user)")
            print("fullName: \(String(describing: appleIDCredential.fullName))")
            print("Email: \(String(describing: appleIDCredential.email))")
            print("realUserStatus: \(String(describing: appleIDCredential.realUserStatus))")
            // 將資料存進 userDefault
            let userDefaults = UserDefaults.standard
            //因為apple除了第一次登入後只會提供 ID，所以獨立存取日後提供登入登出。
            let userAppleID = ["appleID": appleIDCredential.user]
            userDefaults.set(userAppleID, forKey: "UserAppleID")
            FirebaseManager.shared.pushToFirebaseForUser(documentData: userAppleID, appleID: appleIDCredential.user) { err in
                if err == nil {
                    //存取來自 apple 的姓名、信箱
                    if let fullName = appleIDCredential.fullName,
                       let appleEmail = appleIDCredential.email,
                       let name = fullName.givenName {
                        let userDataFromApple: [String: String] = [
                            "fullName": name,
                            "email": appleEmail
                        ]
                        userDefaults.set(userDataFromApple, forKey: "UserDataFromApple")
                        
                            FirebaseManager.shared.editUserDataForFirebase(key: "fullName", value: name)
                            FirebaseManager.shared.editUserDataForFirebase(key: "email", value: appleEmail)
                    }
                    self.navigationController?.popToRootViewController(animated: true)

                }
            }
        }
    }
         /// 授權失敗
         /// - Parameters:
         ///   - controller: _
         ///   - error: _
         func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
             switch (error) {
             case ASAuthorizationError.canceled:
                 break
             case ASAuthorizationError.failed:
                 break
             case ASAuthorizationError.invalidResponse:
                 break
             case ASAuthorizationError.notHandled:
                 break
             case ASAuthorizationError.unknown:
                 break
             default:
                 break
             }
             print("didCompleteWithError: \(error.localizedDescription)")
         }
}
extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    /// - Parameter controller: _
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
           return self.view.window!
    }
}
