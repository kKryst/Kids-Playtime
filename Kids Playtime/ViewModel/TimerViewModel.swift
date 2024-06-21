//
//  TimerViewModel.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 30/05/2024.
//

import Foundation
import Combine


extension TimerView {
    
    class ViewModel: ObservableObject {
        @Published var timeElapsed: TimeInterval = 0
            private var timer: AnyCancellable?
            
            func startTimer() {
                timeElapsed = 0
                timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                    .sink { [weak self] _ in
                        self?.timeElapsed += 1
                    }
            }
            
            func stopTimer() {
                timer?.cancel()
            }
            
            func getTimeString() -> String {
                let hours = Int(timeElapsed) / 3600
                let minutes = (Int(timeElapsed) % 3600) / 60
                let seconds = Int(timeElapsed) % 60
                if hours > 0 {
                    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
                } else {
                    return String(format: "%02d:%02d", minutes, seconds)
                }
            }
        
        func saveElapsedTime() {
            guard let userEmail = UserDefaults.standard.value(forKey: "userEmail") as? String else {
                print("failed to fetch user email from cache")
                return
            }
            let timePlayed = Double((timeElapsed/60).rounded(.up))
            if timePlayed >= 5 {
                // if played for long enough, adds number of games played and minutes
                DatabaseManager.shared.addTimePlayed(for: userEmail, time: timePlayed)
                DatabaseManager.shared.addGamesPlayed(for: userEmail)
            }
        }
    }
}
