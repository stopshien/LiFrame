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
               if let fullName = appleIDCredential.fullName,
                  let appleEmail = appleIDCredential.email {
                   let userAppleID = appleIDCredential.user
                   let name = String(describing: fullName)
                   let email = String(describing: appleEmail)
                   let userDataFromApple: [String: String] = [
                    "user": userAppleID,
                    "fullName": name,
                    "email": email
                   ]
                   userDefaults.set(userDataFromApple, forKey: "UserDataFromApple")
                   navigationController?.popToRootViewController(animated: true)
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
