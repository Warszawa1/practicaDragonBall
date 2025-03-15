//
//  HeroDetailViewController.swift
//  KCDragonBall
//
//  Created by Ire  Av on 15/3/25.
//

import UIKit

class HeroDetailViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var heroDescriptionLabel: UILabel!
    @IBOutlet weak var transformationsButton: UIButton!
    
    // MARK: - Properties
    private let hero: Hero
    
    // MARK: - Initialization
    init(hero: Hero) {
        self.hero = hero
        super.init(nibName: "HeroDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = hero.name
        heroNameLabel.text = hero.name
        heroDescriptionLabel.text = hero.description
        
        // Load hero image
        if let url = URL(string: hero.photo) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.heroImageView.image = image
                    }
                }
            }.resume()
        }
        
        // Hide transformations button by default
        transformationsButton.isHidden = true
        
        checkForTransformations()
    }
    
    private func checkForTransformations() {
        NetworkModel.shared.getTransformations(for: hero) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let transformations):
                    // Show button if there are transformations
                    self?.transformationsButton.isHidden = transformations.isEmpty
                    
                case .failure:
                    // Keep button hidden if there's an error
                    self?.transformationsButton.isHidden = true
                }
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func transformationsButtonTapped(_ sender: UIButton) {
        // We'll implement this later
        print("Transformations button tapped for \(hero.name)")
    }
}
