//
//  GameInfoView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 23/01/2024.
//

import SwiftUI

struct GameInfoView: View {
    
    let gameDetails: GameDetails
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var isDialogPresenting = false
    @State private var shouldPresentOpinionSheet = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background full-size image with blur effect
            AsyncImage(url: URL(string: "\(gameDetails.imageUrl)")) { image in
                image.resizable()
                image.aspectRatio(contentMode: .fill)// Makes the image resizable, cached automatically
            } placeholder: {
                ProgressView() // Placeholder while the image is loading
            }
            .blur(radius: 10)
            .ignoresSafeArea()
            .onTapGesture { // allows user to be able to tap on the image to hide the dialog
                if isDialogPresenting {
                    isDialogPresenting = false
                }
            }
            if isDialogPresenting == false { // shows either game description or dialog
                VStack (spacing: 20){
                    Text(gameDetails.nameOfTheGame)
                        .font(AppFonts.amikoSemiBold(withSize: 24))
                        .foregroundStyle(AppColors.darkBlue.opacity(0.9))
                    Text(gameDetails.gameDescription)
                    .font(AppFonts.amikoRegular(withSize: 16))
                    .foregroundStyle(AppColors.darkBlue.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    
                    Button(action: {
                        isDialogPresenting = true
                    }, label: {
                        Text("Done")
                            .fontWeight(.bold)
                            .font(AppFonts.amikoRegular(withSize: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColors.lightBlue)
                            .cornerRadius(12)
                    })
                }
                .frame(width: 300)
                .padding()
                .background(AppColors.white)
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                .shadow(radius: 20)
            }
            else  { // shows either game description or dialog
                GameInfoDialogView(isActive: $isDialogPresenting, shouldPresentOpinionSheet: $shouldPresentOpinionSheet)
                    .onDisappear(perform: {
                        isDialogPresenting = false
                    })
            }
        }
        .sheet(isPresented: $shouldPresentOpinionSheet, content: {
            GameOpinionView()
                .onDisappear(perform: {
                    if viewRouter.shouldNavigateBackTwice {
                        viewRouter.shouldNavigateBackTwice = false
                        dismiss()
                    }
                })
            
        })
        .onAppear {
            viewRouter.shouldDisplayTabView = false
        }
        .onDisappear(perform: {
            viewRouter.shouldDisplayTabView = true
        })
        
    }
}

#Preview {
    GameInfoView(gameDetails: GameDetails(nameOfTheGame: "Game no 6", minNumberOfPlayers: 2, maxNumberOfPlayers: 3, estimatedTime: 100, imageUrl: "https://cdn.britannica.com/84/73184-050-05ED59CB/Sunflower-field-Fargo-North-Dakota.jpg", gameDescription: "This is a longer description of the game This is a longer description of the game This is a longer description of the game This is a longer description of the game This is a longer description of the game")).environmentObject({ () -> ViewRouter in
        let envObj = ViewRouter()
        envObj.shouldDisplayTabView = false
        return envObj
    }() )
}
