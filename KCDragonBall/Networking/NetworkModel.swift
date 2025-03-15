//
//  NetworkModel.swift
//  KCDragonBall
//
//  Created by Ire  Av on 14/3/25.
//

import Foundation

final class NetworkModel {
    // Singleton
    static let shared = NetworkModel(client: .shared)
    
    // Compose valid URLs
    private var baseComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dragonball.keepcoding.education"
        return components
    }
    
    private let client: APIClient
    private var token: String?
    
    init(client: APIClient) {
        self.client = client
    }
    
    // Login method
    func login(
        user: String,
        password: String,
        completion: @escaping (Result<String, APIClientError>) -> Void
    ){
        // Configure path (URL)
        var components = baseComponents
        components.path = "/api/auth/login"
        // Unpack
        guard let url = components.url else {
            completion(.failure(.malformedURL))
            return
        }
        
        // Create a string user:password
        let loginString = String(format: "%@:%@", user, password)
        
        // Unpack and encode loginString with utf8
        guard let loginData = loginString.data(using: .utf8) else {
            completion(.failure(.decodingFailed))
            return
        }
        
        let base64LoginData = loginData.base64EncodedString()
        
        // Create a request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        client.jwt(request) { [weak self] result in
            switch result {
                case let .success(token):
                    self?.token = token
                case .failure:
                    break
            }
            completion(result)
        }
    }
    
    // GET ALL THE HEROS
    func getHeros(completion: @escaping (Result<[Hero], APIClientError>) -> Void) {
        var components = baseComponents
        components.path = "/api/heros/all"
        
        guard let url = components.url else {
            completion(.failure(.malformedURL))
            return
        }
        
        // Unpack token
        guard let token else {
            completion(.failure(.unknown))
            return
        }
        
        guard let seralizedBody = try? JSONSerialization.data(withJSONObject: ["name": ""]) else {
            completion(.failure(.decodingFailed))
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // Set headers
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = seralizedBody
        
        client.request(request, using: [Hero].self, completion: completion)
    }
    
    func getTransformations(
        for hero: Hero,
        completion: @escaping (Result<[Transformation], APIClientError>) -> Void
    )  {
        var components = baseComponents
        components.path = "/api/heros/tranformations"
        
        guard let url = components.url else {
            completion(.failure(.malformedURL))
            return
        }
        
        guard let token else {
            completion(.failure(.unknown))
            return
        }
        
        guard let serializedBody = try? JSONSerialization.data(withJSONObject: ["id": hero.id]) else {
            completion(.failure(.decodingFailed))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = serializedBody
        
        client.request(request, using: [Transformation].self, completion: completion)
    }
}
