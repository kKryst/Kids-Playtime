//
//  GameOpinionViewModel.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 02/06/2024.
//

import Foundation

extension GameOpinionView {
    
    class ViewModel: ObservableObject {
        @Published var additionalNote: String = ""
        @Published var rate = 1
        
        @Published var kidEngagementButton = false
        @Published var fitToAgeButton = false
        @Published var wasFunGameButton = false
        @Published var willPlayAganButton = false
        
        func addGameRating(gameTitle: String) {
            guard let userEmail = UserDefaults.standard.value(forKey: "userEmail") as? String else {
                print("Failed to fetch user Email from database")
                return
            }
            
            let safeEmail = DatabaseManager.safeEmail(emailAddress: userEmail)
            
            let gameRate = GameRate(rate: rate,
                                    kidEngagementButton: kidEngagementButton,
                                    fitToAgeButton: fitToAgeButton,
                                    wasFunGameButton: wasFunGameButton,
                                    willPlayAganButton: willPlayAganButton, 
                                    additionalNote: additionalNote,
                                    ratingUserEmail: safeEmail)
            DatabaseManager.shared.addGameRate(for: userEmail, title: gameTitle, rate: gameRate)
            
        }
    }
    
}
