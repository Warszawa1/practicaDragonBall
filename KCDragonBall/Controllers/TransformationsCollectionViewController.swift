//
//  TransformationsTableViewController.swift
//  KCDragonBall
//
//  Created by Ire  Av on 15/3/25.
//

import UIKit

class TransformationsCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: - Properties
    private let hero: Hero
    private var transformations: [Transformation] = []
    private var collectionView: UICollectionView!
    
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
        setupCollectionView()
        loadTransformations()
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        title = "\(hero.name) Transformaciones"
        view.backgroundColor = .black
        
        // Create a flow layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        // Create collection view
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Register cell
        collectionView.register(TransformationCell.self, forCellWithReuseIdentifier: "TransformationCell")
        
        view.addSubview(collectionView)
    }
    
    // MARK: - Data Loading
    private func loadTransformations() {
        NetworkModel.shared.getTransformations(for: hero) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let transformations):
                    self?.transformations = transformations
                    self?.collectionView.reloadData()
                    
                case .failure:
                    let alert = UIAlertController(
                        title: "Error",
                        message: "No se han podido cargar las transformationes",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transformations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransformationCell", for: indexPath) as? TransformationCell else {
            return UICollectionViewCell()
        }
        
        let transformation = transformations[indexPath.row]
        cell.configure(with: transformation)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate size based on screen width - adjust as needed
        let width = (collectionView.bounds.width - 30) / 2
        return CGSize(width: width, height: width * 1.5)
    }
}

// MARK: - Custom Cell
class TransformationCell: UICollectionViewCell {
    // UI Elements
    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        // Cell styling
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        
        // Set up scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scrollView)
        scrollView.isDirectionalLockEnabled = true
        
        // Set up content container inside scroll view
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentContainer)
        
        // Set up image view
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(imageView)
        
        // Set up name label
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(nameLabel)
        
        // Set up description label
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.textAlignment = .natural
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(descriptionLabel)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            // Scroll view fills the cell
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Content container inside scroll view
            contentContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Image view at the top
            imageView.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalToConstant: 120), // Fixed height
            
            // Name label below image
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -8),
            
            // Description label at the bottom
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with transformation: Transformation) {
        nameLabel.text = transformation.name
        descriptionLabel.text = transformation.description
        
        // Load image
        if let url = URL(string: transformation.photo) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }.resume()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        descriptionLabel.text = nil
    }
}
