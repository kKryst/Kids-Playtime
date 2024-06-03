//
//  DiscoverViewModel.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 12/02/2024.
//

import Foundation
import SwiftUI
import FirebaseDatabase
import FirebaseDatabaseSwift

extension DiscoverView {
    
    class ViewModel: ObservableObject {
        
        @Published var isGameDialogActive = false
        @Published var scale: CGFloat = 1.0
        @Published var isWheelSpinning = false
        @Published var games: [Game] = []
        @Published var gameTitles: [String] = [""]
        @Published var valueFromFirebase: String = ""
        @Published var currentlySelectedGame: Game?

        func fetchAllGames() {
            DatabaseManager.shared.fetchAllGames { [weak self] games in
                if let games {
                    var modifiedGames: [Game] = []
                    
                    games.forEach { game in
                        let modifiedImageURL = game.imageURL.replacingOccurrences(of: "!", with: "/")
                                                            .replacingOccurrences(of: "_", with: ".")
                        let modifiedGame = Game(title: game.title, imageURL: modifiedImageURL, minNumberOfPlayers: game.minNumberOfPlayers, maxNumberOfPlayers: game.maxNumberOfPlayers, longDescription: game.longDescription, estimatedTime: game.estimatedTime) // Add all necessary properties here
                        modifiedGames.append(modifiedGame)
                    }
                    
                    self?.games = modifiedGames
                    var tempTitles: [String] = []
                    modifiedGames.forEach { game in
                        tempTitles.append(game.title)
                    }
                    self?.gameTitles = tempTitles
                }
            }
        }


        
        func appendGameToDB() {
            DatabaseManager.shared.addGame()
        }
    }
}
