//
//  Game.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 20/05/2024.
//

import Foundation

struct Game: Codable {
    let title: String
    let imageURL: String
    let minNumberOfPlayers: Int
    let maxNumberOfPlayers: Int
    let longDescription: String
    let estimatedTime: Int
}
