//
//  DataFetcher.swift
//  KCDragonBall
//
//  Created by Ire  Av on 16/3/25.
//

import Foundation

enum AppError: Error {
    case network(String)
    case authentication(String)
    case dataFormat(String)
    case serverError(Int)
    case noInternet
    case timeout
    case unknown
    
    var userMessage: String {
        switch self {
        case .network(let details):
            return "Error de conexión: \(details)"
        case .authentication:
            return "Error de autenticación. Comprueba tus credenciales."
        case .dataFormat:
            return "Error de formato de datos."
        case .serverError(let code):
            return "Error del servidor: \(code)"
        case .noInternet:
            return "No hay conexión a Internet. Comprueba tu conexión."
        case .timeout:
            return "La conexión ha excedido el tiempo de espera."
        case .unknown:
            return "Ha ocurrido un error inesperado."
        }
    }
}

// Now let's update the DataFetcher class
class DataFetcher {
    // Singleton
    static let shared = DataFetcher()
    
    private init() {}
    
    func login(email: String, password: String, completion: @escaping (Result<String, AppError>) -> Void) {
        NetworkModel.shared.login(user: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    completion(.success(token))
                case .failure(let apiError):
                    let appError = self.convertToAppError(apiError, context: "login")
                    completion(.failure(appError))
                }
            }
        }
    }
    
    func fetchHeroes(completion: @escaping (Result<[Hero], AppError>) -> Void) {
        NetworkModel.shared.getHeros { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let heroes):
                    completion(.success(heroes))
                case .failure(let apiError):
                    let appError = self.convertToAppError(apiError, context: "fetch heroes")
                    completion(.failure(appError))
                }
            }
        }
    }
    
    func fetchTransformations(for hero: Hero, completion: @escaping (Result<[Transformation], AppError>) -> Void) {
        NetworkModel.shared.getTransformations(for: hero) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let transformations):
                    completion(.success(transformations))
                case .failure(let apiError):
                    let appError = self.convertToAppError(apiError, context: "fetch transformations")
                    completion(.failure(appError))
                }
            }
        }
    }
    
    // Helper method to convert APIClientError to AppError
    private func convertToAppError(_ apiError: APIClientError, context: String) -> AppError {
        switch apiError {
        case .statusCode(let code):
            if let code = code {
                if code == 401 || code == 403 {
                    return .authentication("Credenciales incorrectas o sesión expirada")
                } else if code >= 500 {
                    return .serverError(code)
                } else {
                    return .network("Error \(code) durante \(context)")
                }
            } else {
                return .unknown
            }
        case .noData:
            return .network("No se recibieron datos durante \(context)")
        case .decodingFailed:
            return .dataFormat("Error decodificando datos durante \(context)")
        case .malformedURL:
            return .network("URL incorrecta durante \(context)")
        case .unknown:
            return .unknown
        }
    }
}
