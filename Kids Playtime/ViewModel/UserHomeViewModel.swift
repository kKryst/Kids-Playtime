//
//  UserHomeViewModel.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 08/02/2024.
//

import Foundation
import SwiftUI
import FirebaseAuth

extension UserHomeView {
    
    struct WeeklyData: Identifiable {
        var id = UUID().uuidString
        let nameOfTheWeek: String
        let totalNumberOfGamesPlayed: Int
        let totalNumberOfMinutesPlayed: Int
    }
    
    struct TimeFrameData {
        var xValues: [String]
        var yValues: [Int]
    }
    
    class ViewModel: ObservableObject {
        
        @Published var isUserLoggedIn: Bool = Auth.auth().currentUser != nil
        @Published var data: [UserStatsDataPerDay]
        @Published var minutesPlayed = 0
        @Published var gamesPlayed = 0
        @Published var selectedTimeFrame: TimeFrame = .month {
            didSet {
                calculateMinutesPlayedPerWeek()
                calculateGamesPlayedPerWeek()
                updateChartData()
            }
        }
        @Published var timeFrameData: TimeFrameData?
        @Published var isGameDialogActive = false
        @Published var isLoginDialogActive = false
        @Published var games: [Game] = []
        @Published var currentlySelectedGame: Game? = nil
        
        private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
        
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
            
            
            self.authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
                self?.isUserLoggedIn = user != nil
            }
            
            calculateMinutesPlayedPerWeek()
            calculateGamesPlayedPerWeek()
            updateChartData()
            
        }
        
        deinit {
                if let handle = authStateDidChangeListenerHandle {
                    Auth.auth().removeStateDidChangeListener(handle)
                }
            }
        
        func fetchSavedGames() {
            DatabaseManager.shared.fetchAllGames { [weak self] games in
                if let games {
                    self?.games = games
                }
            }
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
        
        func updateChartData() {
            self.timeFrameData = aggregateDataIntoWeeks()
        }
        
        private func aggregateDataIntoWeeks() -> TimeFrameData {
            switch selectedTimeFrame {
            case .week:
                let daysData = data.prefix(7).map { $0.day }
                let minutesPerDay = data.prefix(7).map { $0.minutesPlayed }
                return TimeFrameData(xValues: daysData, yValues: minutesPerDay)
                
            case .month:
                var weeksLabels = [String]()
                var totalMinutesPerWeek = [Int]()
                let weeks = data.count / 7
                
                for week in 0..<weeks {
                    let startIndex = week * 7
                    let endIndex = min(startIndex + 6, data.count - 1)
                    let weekData = data[startIndex...endIndex]
                    let totalMinutes = weekData.reduce(0) { $0 + $1.minutesPlayed }
                    weeksLabels.append("Week \(week + 1)")
                    totalMinutesPerWeek.append(totalMinutes)
                }
                
                return TimeFrameData(xValues: weeksLabels, yValues: totalMinutesPerWeek)
            }
        }
    }
}
