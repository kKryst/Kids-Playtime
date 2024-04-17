//
//  UserHomeViewModel.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 08/02/2024.
//

import Foundation
import SwiftUI

extension UserHomeView {
    
    class ViewModel: ObservableObject {
        
        @Published var data: [UserStatsData]
        @Published var minutesPlayed = 0
        @Published var gamesPlayed = 0
        @Published var selectedTimeFrame: TimeFrame = .week
        @Published var animateChart = false
        @Published var isGameDialogActive = false
        @Published var isLoginDialogActive = false
        @Published var games = [
            GameCard(nameOfTheGame: "Game no 1", minNumberOfPlayers: 2, maxNumberOfPlayers: 4, estimatedTime: 45, imageUrl: "https://cdn.britannica.com/84/73184-050-05ED59CB/Sunflower-field-Fargo-North-Dakota.jpg"),
            GameCard(nameOfTheGame: "Game no 2", minNumberOfPlayers: 3, maxNumberOfPlayers: 5, estimatedTime: 120, imageUrl: "https://cdn.britannica.com/84/73184-050-05ED59CB/Sunflower-field-Fargo-North-Dakota.jpg"),
            GameCard(nameOfTheGame: "Game no 3", minNumberOfPlayers: 2, maxNumberOfPlayers: 2, estimatedTime: 20, imageUrl: "https://cdn.britannica.com/84/73184-050-05ED59CB/Sunflower-field-Fargo-North-Dakota.jpg"),
            GameCard(nameOfTheGame: "Game no 4", minNumberOfPlayers: 5, maxNumberOfPlayers: 10, estimatedTime: 240, imageUrl: "https://cdn.britannica.com/84/73184-050-05ED59CB/Sunflower-field-Fargo-North-Dakota.jpg"),
            GameCard(nameOfTheGame: "Game no 5", minNumberOfPlayers: 1, maxNumberOfPlayers: 3, estimatedTime: 50, imageUrl: "https://cdn.britannica.com/84/73184-050-05ED59CB/Sunflower-field-Fargo-North-Dakota.jpg")]
        @Published var currentlySelectedGame: GameCard? = nil
        
        init() {
            self.data = [
                UserStatsData(day: "Mon", minutesPlayed: 30, numbersOfGamesPlayed: 2, date: Date()),
                UserStatsData(day: "Tue", minutesPlayed: 40, numbersOfGamesPlayed: 1, date: Date()),
                UserStatsData(day: "Wed", minutesPlayed: 33, numbersOfGamesPlayed: 1, date: Date()),
                UserStatsData(day: "Thu", minutesPlayed: 90, numbersOfGamesPlayed: 3, date: Date()),
                UserStatsData(day: "Fri", minutesPlayed: 0, numbersOfGamesPlayed: 0, date: Date()),
                UserStatsData(day: "Sat", minutesPlayed: 0, numbersOfGamesPlayed: 0, date: Date()),
                UserStatsData(day: "Sun", minutesPlayed: 53, numbersOfGamesPlayed: 2, date: Date())
            ]
            calculateMinutesPlayed()
            calculateGamesPlayed()
        }
        
        func calculateMinutesPlayed() {
                minutesPlayed = data.reduce(0) { $0 + $1.minutesPlayed }
            }
        
        func calculateGamesPlayed() {
            gamesPlayed = data.reduce(0) { $0 + $1.numbersOfGamesPlayed }
        }
    }
}
