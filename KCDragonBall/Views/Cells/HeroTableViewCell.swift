//
//  HeroTableViewCell.swift
//  KCDragonBall
//
//  Created by Ire  Av on 15/3/25.
//

import UIKit


final class HeroTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = String(describing: HeroTableViewCell.self)
    
    // MARK: - Outlets
    
    @IBOutlet var heroImageView: UIImageView!
    @IBOutlet var heroNameLabel: UILabel!
    
    @IBOutlet var heroDescriptionLabel: UILabel!
    
    
    // MARK: - Configuration
    func configure(with hero: Hero) {
        // Basic setup
        heroNameLabel.text = hero.name
        heroDescriptionLabel.text = hero.description
        
        // Load image
        if let url = URL(string: hero.photo) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.heroImageView.image = image
                    }
                }
            }.resume()
        }
    }
}
