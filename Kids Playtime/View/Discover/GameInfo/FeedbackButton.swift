//
//  FeedbackButton.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 27/01/2024.
//

import SwiftUI

struct FeedbackButton: View {
    
    @Binding var buttonTapped: Bool
    var title: String
    
    var body: some View {
        Button {
            buttonTapped.toggle()
        } label: {
            HStack {
                Spacer()
                Text(title)
                    .font(buttonTapped ? AppFonts.amikoBold(withSize: 14) : AppFonts.amikoSemiBold(withSize: 14))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(buttonTapped ? AppColors.lightBlue : AppColors.lightBlue.opacity(0.6))
                    .foregroundColor(AppColors.white)
                    .clipShape(Capsule())
                Spacer()
            }
        }

    }
}

    #Preview {
        FeedbackButton(buttonTapped: .constant(false), title: "Baba daba?")
    }
