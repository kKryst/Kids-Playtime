//
//  GameRate.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 17/04/2024.
//

import Foundation

struct GameRate: Codable {
    let rate: Int
    let kidEngagementButton: Bool
    let fitToAgeButton: Bool
    let wasFunGameButton: Bool
    let willPlayAganButton: Bool
    let additionalNote: String
    
}
