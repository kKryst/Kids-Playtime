//
//  GameDetails.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 16/04/2024.
//

import Foundation

// TODO: poprawki: ten obiekt wymaga tylko tytulu oraz opisu!
struct GameDetails {
    let nameOfTheGame: String // gameCardProperty
    let minNumberOfPlayers: Int // gameCardProperty
    let maxNumberOfPlayers: Int // gameCardProperty
    let estimatedTime: Int // gameCardProperty
    let imageUrl: String // gameCardProperty
    let gameDescription: String // custom property
    
    init(nameOfTheGame: String, minNumberOfPlayers: Int, maxNumberOfPlayers: Int, estimatedTime: Int, imageUrl: String, gameDescription: String) {
        self.nameOfTheGame = nameOfTheGame
        self.minNumberOfPlayers = minNumberOfPlayers
        self.maxNumberOfPlayers = maxNumberOfPlayers
        self.estimatedTime = estimatedTime
        self.imageUrl = imageUrl
        self.gameDescription = gameDescription
    }
    
    init(gameCard: GameCard, gameDescription: String) {
        self.nameOfTheGame = gameCard.nameOfTheGame
        self.minNumberOfPlayers = gameCard.minNumberOfPlayers
        self.maxNumberOfPlayers = gameCard.maxNumberOfPlayers
        self.estimatedTime = gameCard.estimatedTime
        self.imageUrl = gameCard.imageUrl
        self.gameDescription = gameDescription
    }
}
