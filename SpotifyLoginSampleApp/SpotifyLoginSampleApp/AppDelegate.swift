//

import UIKit
import Firebase
import GoogleSignIn

@main

// 현재코드에서 GoogleSignIn의 버전은 6.2
// 버전이 업데이트 되면서 GIDSignInDelegate 사라졌습니다. 버전에 맞게 관련된 코드는 주석 처리 및 삭제를 하였습니다.
class AppDelegate: UIResponder, UIApplicationDelegate{

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        //파이어베이스 초기화
        FirebaseApp.configure()
        
        return true
    }

    //메소드 추가 구글의 인증 프로세스가 끝날때 앱이 수신하는 url이 처리하는 역할
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //GIDSignIn.sharedInstance() -> GIDSignIn.sharedInstance 으로 변경
        return GIDSignIn.sharedInstance.handle(url)
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
}
