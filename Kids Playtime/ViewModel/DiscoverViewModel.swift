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
        @Published var games = [
            GameCard(nameOfTheGame: "Game no 1", minNumberOfPlayers: 2, maxNumberOfPlayers: 4, estimatedTime: 45, imageUrl: "https://cdn.britannica.com/84/73184-050-05ED59CB/Sunflower-field-Fargo-North-Dakota.jpg"),
            GameCard(nameOfTheGame: "Game no 2", minNumberOfPlayers: 3, maxNumberOfPlayers: 5, estimatedTime: 120, imageUrl: "https://cdn.britannica.com/84/73184-050-05ED59CB/Sunflower-field-Fargo-North-Dakota.jpg"),
            GameCard(nameOfTheGame: "Game no 3", minNumberOfPlayers: 2, maxNumberOfPlayers: 2, estimatedTime: 20, imageUrl: "https://cdn.britannica.com/84/73184-050-05ED59CB/Sunflower-field-Fargo-North-Dakota.jpg"),
            GameCard(nameOfTheGame: "Game no 4", minNumberOfPlayers: 5, maxNumberOfPlayers: 10, estimatedTime: 240, imageUrl: "https://cdn.britannica.com/84/73184-050-05ED59CB/Sunflower-field-Fargo-North-Dakota.jpg"),
            GameCard(nameOfTheGame: "Game no 5", minNumberOfPlayers: 1, maxNumberOfPlayers: 3, estimatedTime: 50, imageUrl: "https://cdn.britannica.com/84/73184-050-05ED59CB/Sunflower-field-Fargo-North-Dakota.jpg"),
            GameCard(nameOfTheGame: "Game no 6", minNumberOfPlayers: 2, maxNumberOfPlayers: 3, estimatedTime: 100, imageUrl: "https://cdn.britannica.com/84/73184-050-05ED59CB/Sunflower-field-Fargo-North-Dakota.jpg")]
        @Published var valueFromFirebase: String? = nil
        @Published var currentlySelectedGame: GameCard? = nil
        
        
        func readValue() {
            // if we have this value cached
            if let safeValue = UserDefaults.standard.value(forKey: "value") as? String {
                self.valueFromFirebase = safeValue
                // fetch it from the Database
            } else {
                DatabaseManager.shared.readValue { [weak self] value in
                    DispatchQueue.main.async {
                        self?.valueFromFirebase = value
                        UserDefaults.standard.set(value, forKey: "value")
                    }
                }
            }
        }
        
        func getTitles() -> [String] {
            var titles: [String] = []
            games.forEach { game in
                titles.append(game.nameOfTheGame)
            }
            
            return titles
        }
    }
}
