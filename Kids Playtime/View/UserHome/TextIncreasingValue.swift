//
//  TextIncreasingValue.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 01/02/2024.
//

import SwiftUI

struct TextIncreasingValue: View {
    @State private var value: Int = 0
    @State private var hasCounted: Bool = false
    let endValue: Int // Target value
    let duration: Double // Duration of the animation

    var body: some View {
        Text("\(value)")
            .onAppear {
                if !hasCounted {
                    incrementValue()
                    hasCounted = true
                }
                
            }
    }

    func incrementValue() {
        let steps: Int = 100 // Adjust this for smoother or faster animation
        let timeInterval: Double = duration / Double(steps)

        for step in 1...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval * Double(step)) {
                withAnimation {
                    self.value = Int(Double(endValue) * (Double(step) / Double(steps)))
                }
            }
        }
    }
}
