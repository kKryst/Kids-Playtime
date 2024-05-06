//
//  TextIncreasingValue.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 01/02/2024.
//

import SwiftUI

struct TextIncreasingValue: View {
    @State private var value: Int = 0
    var endValue: Int // Target value
    let duration: Double // Duration of the animation

    var body: some View {
        Text("\(value)")
            .onAppear {
                incrementValue(targetValue: self.endValue)
            }
            .onChange(of: endValue) { newValue in
                incrementValue(targetValue: newValue) //works
            }
    }

    private func incrementValue(targetValue: Int) {
        let steps: Int = 100 // Adjust this for smoother or faster animation
        let timeInterval: Double = duration / Double(steps)
        self.value = 0

        for step in 1...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval * Double(step)) {
                withAnimation {
                    self.value = Int(Double(targetValue) * (Double(step) / Double(steps)))
                }
            }
        }
    }
}
