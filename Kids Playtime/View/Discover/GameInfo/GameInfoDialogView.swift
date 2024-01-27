//
//  GameInfoDialogView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 24/01/2024.
//

import SwiftUI

struct GameInfoDialogView: View {
    
    @Binding var isActive: Bool
    @Binding var shouldPresentOpinionSheet: Bool
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .onTapGesture {
                    close()
                }
            VStack {
                Text("Would you like to rate this game?")
                    .font(AppFonts.amikoSemiBold(withSize: 24))
                    .foregroundStyle(AppColors.darkBlue.opacity(0.9))
                HStack (spacing: 10) {
                    Button(action: {
                        viewRouter.shouldDisplayTabView = true
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Maybe later")
                            .fontWeight(.bold)
                            .font(AppFonts.amikoRegular(withSize: 16))
                            .foregroundColor(AppColors.lightBlue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.lightBlue, lineWidth: 1)
                            )
                    })
                    Button {
                        close()
                        shouldPresentOpinionSheet = true
                    } label: {
                        Text("Sure")
                            .fontWeight(.bold)
                            .font(AppFonts.amikoRegular(withSize: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColors.lightBlue)
                            .cornerRadius(12)
                    }
                }
                
            }
            .frame(width: 300)
            .padding()
            .background(AppColors.white)
            .clipShape(RoundedRectangle(cornerRadius: 20.0))
            .shadow(radius: 20)
            .padding(30)
        }
        .ignoresSafeArea()
    }
    
    func close() {
        withAnimation(.spring) {
            isActive = false
        }
    }
    
}

#Preview {
    GameInfoDialogView(isActive: .constant(true), shouldPresentOpinionSheet: .constant(false))
}
