//
//  GameCard.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 14/04/2024.
//

import Foundation

struct GameCard {
    let nameOfTheGame: String
    let minNumberOfPlayers: Int
    let maxNumberOfPlayers: Int
    let estimatedTime: Int
    let imageUrl: String
    
    
    
    init(nameOfTheGame: String, minNumberOfPlayers: Int, maxNumberOfPlayers: Int, estimatedTime: Int, imageUrl: String) {
        self.nameOfTheGame = nameOfTheGame
        self.minNumberOfPlayers = minNumberOfPlayers
        self.maxNumberOfPlayers = maxNumberOfPlayers
        self.estimatedTime = estimatedTime
        self.imageUrl = imageUrl
    }

}
