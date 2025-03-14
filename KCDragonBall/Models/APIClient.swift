//
//  APIClient.swift
//  KCDragonBall
//
//  Created by Ire  Av on 6/3/25.
//

import Foundation

struct APIClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // Obtaining API's JWT
    func jwt(
        _ request: URLRequest,
        completion: @escaping (String?, Error?) -> Void
    ) {
        let task = session.dataTask(with: request) { data, response, error in
        }
    }
}
