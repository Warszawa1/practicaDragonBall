//
//  SceneDelegate.swift
//  KCDragonBall
//
//  Created by Ire  Av on 6/3/25.
//


import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Setup window
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        // Set the login view controller as the root
        let loginVC = createLoginViewController()
        window.rootViewController = loginVC
        window.makeKeyAndVisible()
    }
    
    private func createLoginViewController() -> UIViewController {
        let loginVC = LoginViewController()
        return loginVC
    }
}
