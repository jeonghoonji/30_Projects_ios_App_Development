//
//  LoginViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 지정훈 on 2022/04/19.
//

import Foundation
import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase


class LoginViewController: UIViewController{
    
    @IBOutlet weak var emailLoginButton: UIButton!
    
    //GIDSignInButton uibutton을 상속하면서 구글 로그인을 실행시켜주는 구글 singIN SDK 객체
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    
    @IBOutlet weak var appleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [emailLoginButton,googleLoginButton,appleLoginButton].forEach({
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = 30
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 네비게이션 바 숨기기
        navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func googleLoginButtonTapped(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
          if let error = error {
              print("ERROR", error.localizedDescription)
            return
          }

          guard let authentication = user?.authentication,
                let idToken = authentication.idToken else { return }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

            Auth.auth().signIn(with: credential) { _, _ in
                self.showMainViewController()
            }
        }
    }
    
    //메인뷰 컨트롤러로 이동 시켜줘야함
    private func showMainViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        navigationController?.show(mainViewController,sender: nil)
    }
    
    @IBAction func appleLoginButtonTapped(_ sender: UIButton) {
        //애플 개발자 계정으로 인한 미구현
    }
}
