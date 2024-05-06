//
//  UserHomeViewModel.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 08/02/2024.
//

import Foundation
import SwiftUI

extension UserHomeView {
    
    struct WeeklyData: Identifiable {
        var id = UUID().uuidString
        let nameOfTheWeek: String
        let totalNumberOfGamesPlayed: Int
        let totalNumberOfMinutesPlayed: Int
    }
    
    class ViewModel: ObservableObject {
        
        @Published var data: [UserStatsDataPerDay]
        @Published var minutesPlayed = 0
        @Published var gamesPlayed = 0
        @Published var selectedTimeFrame: TimeFrame = .month
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
                UserStatsDataPerDay(day: "Mon", minutesPlayed: 30, numbersOfGamesPlayed: 2, date: Date()),
                UserStatsDataPerDay(day: "Tue", minutesPlayed: 40, numbersOfGamesPlayed: 1, date: Date()),
                UserStatsDataPerDay(day: "Wed", minutesPlayed: 33, numbersOfGamesPlayed: 1, date: Date()),
                UserStatsDataPerDay(day: "Thu", minutesPlayed: 90, numbersOfGamesPlayed: 3, date: Date()),
                UserStatsDataPerDay(day: "Fri", minutesPlayed: 0, numbersOfGamesPlayed: 0, date: Date()),
                UserStatsDataPerDay(day: "Sat", minutesPlayed: 0, numbersOfGamesPlayed: 0, date: Date()),
                UserStatsDataPerDay(day: "Sun", minutesPlayed: 53, numbersOfGamesPlayed: 2, date: Date()),
                UserStatsDataPerDay(day: "Mon", minutesPlayed: 30, numbersOfGamesPlayed: 2, date: Date()),
                UserStatsDataPerDay(day: "Tue", minutesPlayed: 40, numbersOfGamesPlayed: 1, date: Date()),
                UserStatsDataPerDay(day: "Wed", minutesPlayed: 33, numbersOfGamesPlayed: 1, date: Date()),
                UserStatsDataPerDay(day: "Thu", minutesPlayed: 90, numbersOfGamesPlayed: 3, date: Date()),
                UserStatsDataPerDay(day: "Fri", minutesPlayed: 0, numbersOfGamesPlayed: 0, date: Date()),
                UserStatsDataPerDay(day: "Sat", minutesPlayed: 0, numbersOfGamesPlayed: 0, date: Date()),
                UserStatsDataPerDay(day: "Sun", minutesPlayed: 53, numbersOfGamesPlayed: 2, date: Date()),
            ]
            calculateMinutesPlayedPerWeek()
            calculateGamesPlayedPerWeek()

        }
        
        func calculateMinutesPlayedPerWeek() {
            switch selectedTimeFrame {
            case .week:
                let tempData = data.prefix(7)
                let tempValue = tempData.reduce(0) {$0 + $1.minutesPlayed }
                minutesPlayed = tempValue
            case .month:
                let tempValue = data.reduce(0) { $0 + $1.minutesPlayed }
                minutesPlayed = tempValue
            }
        }
        
        func calculateGamesPlayedPerWeek() {
            switch selectedTimeFrame {
            case .week:
                let tempData = data.prefix(7)
                gamesPlayed = tempData.reduce(0) { $0 + $1.numbersOfGamesPlayed }
            case .month:
                gamesPlayed = data.reduce(0) { $0 + $1.numbersOfGamesPlayed }
            }
        }
        
        
//        private func aggregateDataIntoWeeks() -> [WeeklyData] {
//            var weeklySummaries: [WeeklyData] = []
//            let weeks = data.count / 7 // Calculate the number of complete weeks
//            
//            for week in 0..<weeks {
//                let startIndex = week * 7
//                let endIndex = min(startIndex + 6, data.count - 1) // Ensure the index does not go out of bounds
//                let weekData = data[startIndex...endIndex]
//                let totalMinutes = weekData.reduce(0) { $0 + $1.minutesPlayed }
//                let totalGames = weekData.reduce(0) { $0 + $1.numbersOfGamesPlayed }
//                
//                let weekSummary = WeeklyData(
//                    nameOfTheWeek: "Week \(week + 1)",
//                    totalNumberOfGamesPlayed: totalGames,
//                    totalNumberOfMinutesPlayed: totalMinutes
//                )
//                weeklySummaries.append(weekSummary)
//            }
//            
//            return weeklySummaries
//        }
        
    }
}
