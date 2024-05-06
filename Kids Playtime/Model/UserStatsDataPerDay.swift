//
//  UserStatsData.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 02/02/2024.
//

import Foundation

struct UserStatsDataPerDay: Identifiable {
    var id = UUID().uuidString
    let day: String
    let minutesPlayed: Int
    let numbersOfGamesPlayed: Int
    let date: Date
    var animated: Bool = false
}

enum TimeFrame: String, CaseIterable, Identifiable {
    case week, month
    var id: Self { self }
}
