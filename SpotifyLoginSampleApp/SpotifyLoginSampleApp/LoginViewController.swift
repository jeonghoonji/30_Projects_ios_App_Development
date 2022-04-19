//
//  LoginViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 지정훈 on 2022/04/19.
//

import Foundation
import UIKit
import GoogleSignIn

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
        
        // 숨기기
        navigationController?.navigationBar.isHidden = true
        
        //구글 사인인
        GIDSignIn.sharedInstance().presentingViewController = self
    }
    
    
    @IBAction func googleLoginButtonTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func appleLoginButtonTapped(_ sender: UIButton) {
        
    }
}
