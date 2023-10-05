//
//  SignInViewController.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/9/27.
//

import UIKit
import AuthenticationServices
import CMHUD

class SignInViewController: UIViewController {

    static let shared = SignInViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lutCollectionViewColor
        view.addSubview(signInButton)
        setSignInWithAppleButtonLayout()
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
    func setSignInWithAppleButtonLayout() {
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            signInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
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
                }
            }
        }
        guard let image = UIImage(systemName: "door.left.hand.open") else { return }
        CMHUD.show(image: image, in: view, identifier: "Log in", imageSize: CGSize(width: 100, height: 100))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            CMHUD.hide(from: self.view)
            self.navigationController?.popToRootViewController(animated: true)
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
