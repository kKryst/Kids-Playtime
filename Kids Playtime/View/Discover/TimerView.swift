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
//            Image(systemName: "clock")
//                .resizable()
//                .frame(width: 18, height: 18)
//                .scaleEffect(1.5)
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
        // Implement your database saving logic here
        print("Time elapsed: \(time) seconds")
        // Example: DatabaseManager.shared.saveTime(time)
    }
}


#Preview {
    TimerView()
}
