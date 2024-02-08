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
