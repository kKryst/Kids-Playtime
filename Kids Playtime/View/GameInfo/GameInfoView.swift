//
//  GameInfoView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 23/01/2024.
//

import SwiftUI

struct GameInfoView: View {
    
    @State private var isDialogPresenting = false
    var body: some View {
        ZStack {
            // Background full-size image with blur effect
            Image("imag")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 10)
                .ignoresSafeArea()
                .onTapGesture { // allows user to be able to tap on the image to hide the dialog
                    if isDialogPresenting {
                        isDialogPresenting = false
                    }
                }
            if isDialogPresenting == false { // shows either game description or dialog
                VStack (spacing: 20){
                    Text("title of the game")
                        .font(AppFonts.amikoSemiBold(withSize: 24))
                        .foregroundStyle(AppColors.darkBlue.opacity(0.9))
                    Text("a bit longer description about the game and how to play it. this description will probably take up to couple of lines of text but that should not be a problem for this view. This text should be formatted properly, having the appfont and proper colors a bit longer description about the game and how to play it. this description will probably take up to couple of lines of text but that should not be a problem for this view. This text should be formatted properly, having the appfont and proper colors "
                    )
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
                GameInfoDialogView(isActive: $isDialogPresenting)
                    .onDisappear(perform: {
                        isDialogPresenting = false
                    })
            }
        }
    }
    
}

#Preview {
    GameInfoView()
}
