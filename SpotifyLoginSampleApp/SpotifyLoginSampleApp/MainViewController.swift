//
//  MainViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 지정훈 on 2022/04/16.
//

import Foundation
import UIKit
import FirebaseAuth

class MainViewController : UIViewController{
    
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션 바 숨기기
        navigationController?.navigationBar.isHidden = true
        
        let email = Auth.auth().currentUser?.email ?? "고객"
        welcomeLabel.text = """
        환영합니다.
        \(email)님
        """
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        // signout함수 추가할 예정 인데
        // signout함수 쓰로우 함수이기때문에 do catch 이용
        do{
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        }catch let signOutError as NSError{
            print("ERROR: signout \(signOutError.localizedDescription)")
        }       
    }
}
