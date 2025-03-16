//
//  APIClientMock.swift
//  KCDragonBall
//
//  Created by Ire  Av on 16/3/25.
//

import Foundation
@testable import KCDragonBall

struct APIClientMock {
    // Use variables that can be set from outside rather than modifying internally
    var capturedRequest: URLRequest?
    var jwtToReturn: Result<String, APIClientError>?
    var requestToReturn: Result<Any, APIClientError>?
    
    func jwt(
        _ request: URLRequest,
        completion: @escaping (Result<String, APIClientError>) -> Void
    ) {
        // Instead of modifying self, use a separate variable to capture the request
        // This is passed back via a closure
        var mutableSelf = self
        mutableSelf.capturedRequest = request
        
        if let result = jwtToReturn {
            completion(result)
        }
    }
    
    func request<T: Decodable>(
        _ request: URLRequest,
        using: T.Type,
        completion: @escaping (Result<T, APIClientError>) -> Void
    ) {
        // Same approach here
        var mutableSelf = self
        mutableSelf.capturedRequest = request
        
        if let result = requestToReturn as? Result<T, APIClientError> {
            completion(result)
        }
    }
}
