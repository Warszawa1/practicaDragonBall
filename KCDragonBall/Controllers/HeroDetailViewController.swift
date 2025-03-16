//
//  HeroDetailViewController.swift
//  KCDragonBall
//
//  Created by Ire  Av on 15/3/25.
//

import UIKit

class HeroDetailViewController: UIViewController {
    // MARK: - Properties
    private let hero: Hero
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let heroImageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let transformationsButton = UIButton(type: .system)
    
    // MARK: - Initialization
    init(hero: Hero) {
        self.hero = hero
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithHero()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = hero.name
        view.backgroundColor = .white
        
        // Set up scroll view
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Set up content view
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Set up image view
        contentView.addSubview(heroImageView)
        heroImageView.translatesAutoresizingMaskIntoConstraints = false
        heroImageView.contentMode = .scaleAspectFit
        heroImageView.clipsToBounds = true
        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            heroImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // Set up name label
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        // Set up description label
        contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        // Set up transformations button
        contentView.addSubview(transformationsButton)
        transformationsButton.translatesAutoresizingMaskIntoConstraints = false
        transformationsButton.setTitle("Transformations", for: .normal)
        transformationsButton.backgroundColor = .systemBlue
        transformationsButton.setTitleColor(.white, for: .normal)
        transformationsButton.layer.cornerRadius = 8
        transformationsButton.addTarget(self, action: #selector(transformationsButtonTapped), for: .touchUpInside)
        transformationsButton.isHidden = true // Hide by default
        NSLayoutConstraint.activate([
            transformationsButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            transformationsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            transformationsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            transformationsButton.heightAnchor.constraint(equalToConstant: 50),
            transformationsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func configureWithHero() {
        nameLabel.text = hero.name
        descriptionLabel.text = hero.description
        
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
        
        // Check for transformations
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
    @objc private func transformationsButtonTapped() {
        let transformationsVC = TransformationsCollectionViewController(hero: hero)
            navigationController?.pushViewController(transformationsVC, animated: true)
    }
}
