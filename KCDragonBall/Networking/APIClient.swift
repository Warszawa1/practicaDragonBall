//
//  APIClient.swift
//  KCDragonBall
//
//  Created by Ire  Av on 6/3/25.
//

import Foundation

enum APIClientError: Error, Equatable {
    case malformedURL
    case noData
    case statusCode(code: Int?)
    case decodingFailed
    case unknown
}


// Has a reference to session and throw a given request configures a datatask and sends it (resume()*)
// The response (dataresponse and error) is parsed and we obtain a JWT or some type (decodedModel)
struct APIClient {
    // Singleton
    static let shared = APIClient()
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // Obtaining API's JWT
    func jwt(
        _ request: URLRequest,
        completion: @escaping (Result<String, APIClientError>) -> Void
    ) {
        let task = session.dataTask(with: request) { data, response, error in
            // Checking if there are errors
            guard error == nil else {
                // If there is one, sending it to completion
                if let error = error as? NSError {
                    completion(.failure(.statusCode(code: error.code)))
                } else {
                    completion(.failure(.unknown))
                }
                return
            }
            
            // Checking if there is data
            guard let data else {
                // if not, sending `.noData` error
                completion(.failure(.noData))
                return
            }
            
            let response = response as? HTTPURLResponse
            
            // Checking if the response is 200 (OK)
            guard let response, response.statusCode == 200 else {
                completion(.failure(.statusCode(code: response?.statusCode)))
                return
            }
            
            // We proceed to decode it
            guard let jwt = String.init(data: data, encoding: .utf8) else {
                completion(.failure(.decodingFailed))
                return
            }
            
            completion(.success(jwt))
        }
        
        // KEY TO EXECUTE THE TASK!**************************************** NOT TO FORGET
        task.resume()
    }
    
    // Used with Hero and Transformation
    // for this request method, T is Decodable
    // for the using parameter, T.Type, will be both, Hero and Transformation
    func request<T: Decodable>(
        _ request: URLRequest,
        using: T.Type,
        completion: @escaping (Result<T, APIClientError>) -> Void
    ) {
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                if let error = error as? NSError {
                    completion(.failure(.statusCode(code: error.code)))
                } else {
                    completion(.failure(.unknown))
                }
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            let response = response as? HTTPURLResponse
            
            guard let response, response.statusCode == 200 else  {
                completion(.failure(.statusCode(code: response?.statusCode)))
                return
            }
            
            // UNpack the decodedData object
            guard let decodedModel =  try? JSONDecoder().decode(using, from: data)  else {
                completion(.failure(.decodingFailed))
                return
            }
            
            completion(.success(decodedModel))
        }
        
        // KEY TO EXECUTE THE TASK!**************************************** NOT TO FORGET
        task.resume()
    }
}
