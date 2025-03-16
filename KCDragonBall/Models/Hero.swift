//
//  Hero.swift
//  KCDragonBall
//
//  Created by Ire  Av on 6/3/25.
//

import Foundation

struct Hero: Codable, Equatable {
    let id: String
    let name: String
    let favorite: Bool
    let photo: String
    let description: String
}
