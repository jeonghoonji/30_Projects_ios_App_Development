//
//  AppDelegate.swift
//  SpotifyLoginSampleApp
//
//  Created by 지정훈 on 2022/04/19.
//

import UIKit
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate{

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        //파이어베이스 초기화
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        return true
    }

    //메소드 추가 구글의 인증 프로세스가 끝날때 앱이 수신하는 url이 처리하는 역할
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    //아직 구현 안함
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Error Google Sign In\(error.localizedDescription)")
            return
        }
        guard let authentication = user.authentication else {return}
        
        
        //credential 구글 <- 아이디 토큰 ,액세서토큰 부여 받은거 권한 위임
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken , accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { _, _ in
            //이상한거 
            self.showMainViewController()
        }
    }
    private func showMainViewController(){
        
        //인터넷에서 찾은거
//        let scenes = UIApplication.shared.connectedScenes
//        let windowScenes = scenes.first as? UIWindowScene
//        let window = windowScenes?.windows.first
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        UIApplication.shared.windows.first?.rootViewController?.show(mainViewController,sender: nil)
    }
    

}

