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
        
        func fetchAllGames() {
            DatabaseManager.shared.fetchAllGames { [weak self] games in
                if let games {
                    self?.games = games
                    var tempTitles: [String] = []
                    games.forEach { game in
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
