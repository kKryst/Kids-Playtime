//
//  GameInfoView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 23/01/2024.
//

import SwiftUI

struct GameInfoView: View {
    
    let game: Game
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var isDialogPresenting = false
    @State private var shouldPresentOpinionSheet = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background full-size image with blur effect
            Image("imag")
                .resizable()
                .ignoresSafeArea()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 10)
                .ignoresSafeArea()
                .onTapGesture { // allows user to be able to tap on the image to hide the dialog
                    if isDialogPresenting {
                        isDialogPresenting = false
                    }
                }
            
            // shows either game description or dialog
                VStack (spacing: 20){
                    HStack {
                        Text(game.title)
                            .font(AppFonts.amikoSemiBold(withSize: 24))
                            .foregroundStyle(AppColors.darkBlue.opacity(0.9))
                        TimerView()
                    }
                    Text(game.longDescription)
                        .font(AppFonts.amikoRegular(withSize: 16))
                        .foregroundStyle(AppColors.darkBlue.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                    
                    HStack {
                        Button(action: {
                            isDialogPresenting = true
                        }, label: {
                            HStack {
                                Image(systemName: "heart")
                                    .foregroundStyle(AppColors.pink)
                                    .scaleEffect(1.5)
                                Text("Save")
                                    .fontWeight(.bold)
                                    .font(AppFonts.amikoRegular(withSize: 18))
                                    .foregroundColor(AppColors.lightBlue)
                                
                            }
                            .padding()
                            .frame(width: 120)
                            .cornerRadius(12)
                            .background(AppColors.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.lightBlue, lineWidth: 2)
                            )
                        })
                        Button(action: {
                            isDialogPresenting = true
                        }, label: {
                            Text("Done")
                                .fontWeight(.bold)
                                .font(AppFonts.amikoRegular(withSize: 18))
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 120)
                                .background(AppColors.lightBlue)
                                .cornerRadius(12)
                        })
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(width: 300)
                .padding()
                .background(AppColors.white)
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                .shadow(radius: 20)

            if isDialogPresenting == true  { // shows either game description or dialog
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
    GameInfoView(game: Game(date: "202420051943", title: "Test game 1", imageURL: "", minNumberOfPlayers: 3, maxNumberOfPlayers: 6, longDescription: "This is a long desscription", estimatedTime: 40)).environmentObject({ () -> ViewRouter in
        let envObj = ViewRouter()
        envObj.shouldDisplayTabView = false
        return envObj
    }() )
}
