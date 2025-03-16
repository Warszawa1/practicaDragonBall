//
//  SplashViewController.swift
//  KCDragonBall
//
//  Created by Ire  Av on 16/3/25.
//

import UIKit

class SplashViewController: UIViewController {
    private let dragonBallImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // Set background to black
        view.backgroundColor = .black
        
        // Configure Dragon Ball image
        dragonBallImageView.image = UIImage(named: "dragonball")
        dragonBallImageView.contentMode = .scaleAspectFit
        dragonBallImageView.translatesAutoresizingMaskIntoConstraints = false
        dragonBallImageView.alpha = 0 // Start invisible
        view.addSubview(dragonBallImageView)
        
        // Position the Dragon Ball initially in the top-left corner
        NSLayoutConstraint.activate([
            dragonBallImageView.widthAnchor.constraint(equalToConstant: 100),
            dragonBallImageView.heightAnchor.constraint(equalToConstant: 100),
            dragonBallImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -50),
            dragonBallImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -50)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Animate the Dragon Ball
        UIView.animate(withDuration: 0.1) {
            // Make it visible instantly
            self.dragonBallImageView.alpha = 1
        } completion: { _ in
            // Then animate movement to center with slight delay
            UIView.animate(withDuration: 1.8, delay: 0.8, options: .curveEaseOut) {
                // Remove constraints programmatically
                NSLayoutConstraint.deactivate(self.dragonBallImageView.constraints)
                
                // Add new center constraints
                self.dragonBallImageView.center = self.view.center
                self.dragonBallImageView.frame.size = CGSize(width: 150, height: 150)
            } completion: { _ in
                // Wait a moment before transitioning to the login screen
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                    self.navigateToLoginScreen()
                }
            }
        }
    }
    
    private func navigateToLoginScreen() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
}
