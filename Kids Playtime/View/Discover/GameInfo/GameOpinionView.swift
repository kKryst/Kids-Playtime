//
//  GameOpinionView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 27/01/2024.
//

import SwiftUI

struct GameOpinionView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    @FocusState private var isFirstResponder :Bool
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var networkManager: NetworkManager
    
    @State private var noInternetAlert = false
    
    let gameTitle: String
    
    
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
                    
                    StarRatingView(rating: $viewModel.rate)
                    
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
                        FeedbackButton(buttonTapped: $viewModel.kidEngagementButton, title: "Kids liked it")
                        FeedbackButton(buttonTapped: $viewModel.fitToAgeButton, title: "Fit to age")
                    }
                    HStack {
                        FeedbackButton(buttonTapped: $viewModel.wasFunGameButton, title: "Game was fun")
                        FeedbackButton(buttonTapped: $viewModel.willPlayAganButton, title: "Will play again")
                    }
                    Divider()
                        .padding()
                    
                    TextField("Tell us more about this game...", text: $viewModel.additionalNote)
                        .font(AppFonts.amikoRegular(withSize: 16))
                        .foregroundColor(AppColors.darkBlue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .cornerRadius(10)
                        .focused($isFirstResponder)
                    
                    Button{
                        addGameRating()
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
        .alert(
            "Could not rate this game. Please check your Internet connection.",
            isPresented: $noInternetAlert
        ) {}
        .onTapGesture {
            isFirstResponder = false
        }
    }
    
    func addGameRating() {
        guard networkManager.isConnected else {
            noInternetAlert = true
            return
        }
        viewModel.addGameRating(gameTitle: gameTitle)
        viewRouter.shouldNavigateBackTwice = true
        dismiss()
    }
}

#Preview {
    GameOpinionView(gameTitle: "Test")
}


