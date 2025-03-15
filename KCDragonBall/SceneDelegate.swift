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
        
        // Login first to get token
        NetworkModel.shared.login(
            user: "iantelo@uoc.edu",
            password: "54321"
        ) { result in
            DispatchQueue.main.async {
                // Create heroes view controller
                let heroesVC = HeroesTableViewController()
                let navigationController = UINavigationController(rootViewController: heroesVC)
                
                // Set as root view controller
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
                
                print("Login result: \(result)")
            }
        }
    }
    
    private func fetchHeroes() {
        print("Fetching heroes...")
        let networkModel = NetworkModel.shared
        
        networkModel.getHeros { [weak self] result in
            switch result {
            case .success(let heroes):
                print("Successfully fetched \(heroes.count) heroes:")
                heroes.forEach { print("- \($0.name)") }
                
                // Optionally fetch transformations for Goku
                if let goku = heroes.first(where: { $0.name == "Goku" }) {
                    self?.fetchTransformations(for: goku)
                }
                
            case .failure(let error):
                print("Failed to fetch heroes: \(error)")
            }
        }
    }
    
    private func fetchTransformations(for hero: Hero) {
        print("Fetching transformations for \(hero.name)...")
        let networkModel = NetworkModel.shared
        
        networkModel.getTransformations(for: hero) { result in
            switch result {
            case .success(let transformations):
                print("Successfully fetched \(transformations.count) transformations for \(hero.name):")
                transformations.forEach { print("- \($0.name)") }
                
            case .failure(let error):
                print("Failed to fetch transformations: \(error)")
            }
        }
    }
}
