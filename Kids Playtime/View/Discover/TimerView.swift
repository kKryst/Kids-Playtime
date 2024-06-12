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
            viewModel.saveElapsedTime()
        }
    }
}


#Preview {
    TimerView()
}
