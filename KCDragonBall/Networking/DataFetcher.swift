//
//  DataFetcher.swift
//  KCDragonBall
//
//  Created by Ire  Av on 16/3/25.
//

import Foundation

class DataFetcher {
    // Singleton
    static let shared = DataFetcher()
    
    private init() {}
    
    func login(email: String, password: String, completion: @escaping (Result<String, APIClientError>) -> Void) {
        NetworkModel.shared.login(user: email, password: password) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func fetchHeroes(completion: @escaping (Result<[Hero], APIClientError>) -> Void) {
        NetworkModel.shared.getHeros { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func fetchTransformations(for hero: Hero, completion: @escaping (Result<[Transformation], APIClientError>) -> Void) {
        NetworkModel.shared.getTransformations(for: hero) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
