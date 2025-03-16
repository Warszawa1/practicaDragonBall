//
//  HeroesTableViewController.swift
//  KCDragonBall
//
//  Created by Ire  Av on 15/3/25.
//


import UIKit

class HeroesTableViewController: UITableViewController {
    // MARK: - Properties
    var heroes: [Hero] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dragon Ball Heroes"
        setupTableView()
        
        // For development - directly load from API
        loadHeroes()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        // Register cell
        tableView.register(
            UINib(nibName: "HeroTableViewCell", bundle: nil),
            forCellReuseIdentifier: HeroTableViewCell.identifier
        )
        
        // Simple styling
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.backgroundColor = .white
    }
    
    // MARK: - Data Loading
    private func loadHeroes() {
//        let networkModel = NetworkModel.shared
        
        DataFetcher.shared.fetchHeroes { [weak self] result in
        
                switch result {
                case .success(let heroes):
                    self?.heroes = heroes
                    self?.tableView.reloadData()
                    
                case .failure(let error):
                    print("Failed to load heroes: \(error)")
                    // Could show an alert here
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HeroTableViewCell.identifier,
            for: indexPath
        ) as? HeroTableViewCell else {
            return UITableViewCell()
        }
        
        let hero = heroes[indexPath.row]
        cell.configure(with: hero)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // Simple fixed height
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let hero = heroes[indexPath.row]
        let detailVC = HeroDetailViewController(hero: hero)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
