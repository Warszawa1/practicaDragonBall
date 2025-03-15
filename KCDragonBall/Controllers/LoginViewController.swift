//
//  LoginViewController.swift
//  KCDragonBall
//
//  Created by Ire  Av on 15/3/25.
//

import Foundation


import UIKit

class LoginViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Login"
        activityIndicator.isHidden = true
        
        // Simple styling for the login button
        loginButton.layer.cornerRadius = 8
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            // Show alert for empty fields
            let alert = UIAlertController(
                title: "Error",
                message: "Please enter both email and password",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        // Start loading indication
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        loginButton.isEnabled = false
        
        // Attempt login
        NetworkModel.shared.login(user: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
                self?.loginButton.isEnabled = true
                
                switch result {
                case .success:
                    // Navigate to heroes list
                    let heroesVC = HeroesTableViewController()
                    let navController = UINavigationController(rootViewController: heroesVC)
                    navController.modalPresentationStyle = .fullScreen
                    self?.present(navController, animated: true)
                    
                case .failure:
                    // Show error alert
                    let alert = UIAlertController(
                        title: "Login Failed",
                        message: "Please check your credentials and try again",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}
