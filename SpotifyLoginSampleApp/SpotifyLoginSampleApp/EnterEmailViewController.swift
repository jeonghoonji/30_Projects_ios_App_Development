//
//  EnterEmailViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 지정훈 on 2022/04/16.
//

import Foundation
import UIKit
import FirebaseAuth

class EnterEmailViewController : UIViewController{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorTextField: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        //버튼 비활성화
        nextButton.isEnabled = false
        nextButton.layer.cornerRadius = 30
        
        //UITextFieldDelegate 선언문
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
        // 새로운 화면을 켰을때 이메일작성칸으로 바로 가게
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //네비게이션 바 보이게
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        debugPrint("클릭")
        //파이어베이스 이메일/비밀번호 인증
        // 빈값이라면 옵셔널 처리
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        //신규 사용자 생성
        Auth.auth().createUser(withEmail: email, password: password){ [weak self] authResult, error in
            guard let self = self else {return}
            //동일한 이메일 중복 방지 로그인 회원가입ㅂ?
            if let error = error {
                let code = ( error as NSError).code
                switch code{
                    //이미 가입한 게정일때
                case 17007:
                    self.loginUser(withEmail: email, password: password)
                default:
                    self.errorTextField.text = error.localizedDescription
                }
            }else{
                //로그인이 제대로 됬으면 화면이 넘어감
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

    private func loginUser(withEmail email: String , password: String) {
        Auth.auth().signIn(withEmail: email, password: password ){ [weak self] _, error in
            guard let self = self else { return }
            
             if let error = error{
                 self.errorTextField.text = error.localizedDescription
            }else{
                self.showMainViewController()
            }
        }
    }
    
}


extension EnterEmailViewController : UITextFieldDelegate{
    // 리턴 버튼이 눌렸을때 키보드 내려가게
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = emailTextField.text == ""
        let isPasswordEmpty = passwordTextField.text == ""
        nextButton.isEnabled = !isEmailEmpty && !isPasswordEmpty
    }
}
