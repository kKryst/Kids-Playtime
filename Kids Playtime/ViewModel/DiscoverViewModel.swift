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
        
        
        func readDatabase() {
            // if we have this value cached
            if let safeValue = UserDefaults.standard.value(forKey: "value") as? String {
                self.valueFromFirebase = safeValue
//                // fetch it from the Database
            } else {
                DatabaseManager.shared.readValue { [weak self] value in
                    DispatchQueue.main.async {
                        if let value {
                            self?.valueFromFirebase = value
                            print(value)
                            UserDefaults.standard.set(value, forKey: "value")
                        }
                    }
                }
            }
        }
        // https://firebasestorage.googleapis.com/v0/b/kids-playtime.appspot.com/o/gameImages%2FBackyard-Camping-Adventure.jpg?alt=media&token=3b8d124e-f1eb-4da9-b60b-4dd92ac204ad
        
        // https://firebasestorage.googleapis.com/v0/b/kids/playtime.appspot.com/o/gameImages%2FBackyard/Camping/Adventure.jpg?alt=media&token=3b8d124e/f1eb/4da9/b60b/4dd92ac204ad
        
        func fetchAllGames() {
            DatabaseManager.shared.fetchAllGames { [weak self] games in
                if var games {
                    var modifiedGames: [Game] = []
                    
                    games.forEach { game in
                        let modifiedImageURL = game.imageURL.replacingOccurrences(of: "!", with: "/")
                                                            .replacingOccurrences(of: "_", with: ".")
                        let modifiedGame = Game(title: game.title, imageURL: modifiedImageURL, minNumberOfPlayers: game.minNumberOfPlayers, maxNumberOfPlayers: game.maxNumberOfPlayers, longDescription: game.longDescription, estimatedTime: game.estimatedTime) // Add all necessary properties here
                        modifiedGames.append(modifiedGame)
                        print("modified game imageURL : \(modifiedImageURL)")
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
        
        func readGame() {
            DatabaseManager.shared.fetchFirstGame()
        }
    }
}
