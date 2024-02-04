//
//  GameOpinionView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 27/01/2024.
//

import SwiftUI

struct GameOpinionView: View {
    
    @State var additionalNote: String = ""
    @State var rate = 1
    
    @State var kidEngagementButton = false
    @State var fitToAgeButton = false
    @State var wasFunGameButton = false
    @State var willPlayAganButton = false
    
    @FocusState private var isFirstResponder :Bool
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            AppColors.white.ignoresSafeArea()
            VStack {
                VStack {
                    HStack {
                        Text("Rate this game")
                            .font(AppFonts.amikoSemiBold(withSize: 24))
                            .foregroundStyle(AppColors.darkBlue)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
                    
                    HStack {
                        Text("How would you rate this game?")
                            .font(AppFonts.amikoRegular(withSize: 14))
                            .foregroundStyle(AppColors.white.opacity(0.7))
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    StarRatingView(rating: $rate)
                    
                    Divider()
                        .padding()
                    
                    HStack {
                        Text("Tell us what was good about this game")
                            .font(AppFonts.amikoSemiBold(withSize: 16))
                            .foregroundStyle(AppColors.darkBlue)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
                    
                    HStack {
                        FeedbackButton(buttonTapped: $kidEngagementButton, title: "Kids liked it")
                        FeedbackButton(buttonTapped: $fitToAgeButton, title: "Fit to age")
                    }
                    HStack {
                        FeedbackButton(buttonTapped: $wasFunGameButton, title: "Game was fun")
                        FeedbackButton(buttonTapped: $willPlayAganButton, title: "Will play again")
                    }
                    Divider()
                        .padding()
                    
                    TextField("Tell us more about this game...", text: $additionalNote)
                        .font(AppFonts.amikoRegular(withSize: 16))
                        .foregroundColor(AppColors.darkBlue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .cornerRadius(10)
                        .focused($isFirstResponder)
                    
                    Button{
                        //TODO: send feedback to database
                        dismiss()
                    } label: {
                        Text("Submit")
                            .fontWeight(.bold)
                            .font(AppFonts.amikoRegular(withSize: 16))
                            .foregroundColor(.white)
                            .frame(width: 300)
                            .padding()
                            .background(AppColors.lightBlue)
                            .cornerRadius(12)
                    }
                }
            }
        }
        .onTapGesture {
            isFirstResponder = false
        }
    }
}

#Preview {
    GameOpinionView()
}


