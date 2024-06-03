//
//  TimerView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 30/05/2024.
//

import SwiftUI

struct TimerView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        HStack {
            Text(viewModel.getTimeString())
                .font(AppFonts.amikoSemiBold(withSize: 24))
                .padding(4)
        }
        .onAppear {
            viewModel.startTimer()
        }
        .onDisappear {
            viewModel.stopTimer()
            saveElapsedTime(viewModel.timeElapsed)
        }
    }
    
    private func saveElapsedTime(_ time: TimeInterval) {
        guard let userEmail = UserDefaults.standard.value(forKey: "userEmail") as? String else {
            print("failed to fetch user email from cache")
            return
        }
        print("Time elapsed: \(Double((time/60).rounded(.up))) minutes")
        let timePlayed = Double((time/60).rounded(.up))
        DatabaseManager.shared.addTimePlayed(for: userEmail, time: timePlayed)
        if timePlayed >= 1 {
            // if played long enough, adds number of games played
            DatabaseManager.shared.addGamesPlayed(for: userEmail)
        }
        
    }
}


#Preview {
    TimerView()
}
