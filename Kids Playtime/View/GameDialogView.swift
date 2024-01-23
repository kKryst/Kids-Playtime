//
//  GameAlertView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 18/01/2024.
//

import SwiftUI

struct GameDialogView: View {
    
    @Binding var isActive: Bool
    let title: String
    let players: String
    let time: String
    let image: String
    @State private var offset: CGFloat = 1000
    
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .onTapGesture {
                    close()
                }
            VStack (spacing: 10) {
                Image(image)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 17.0))
                    .padding(8)
                    .frame(width: 200, height: 200)
                HStack {
                    Spacer()
                    Text(title).font(AppFonts.amikoSemiBold(withSize: 24)).foregroundStyle(AppColors.darkBlue.opacity(0.9))
                    Spacer()
                }
                HStack (spacing: 30){
                    VStack {
                        Text("players").font(AppFonts.amikoSemiBold(withSize: 18)).foregroundStyle(AppColors.darkBlue.opacity(0.9))
                        Text(players).font(AppFonts.amikoRegular(withSize: 16)).foregroundStyle(AppColors.darkBlue.opacity(0.7))
                    }
                    VStack {
                        Text("est. time").font(AppFonts.amikoSemiBold(withSize: 18)).foregroundStyle(AppColors.darkBlue)
                        Text(time).font(AppFonts.amikoRegular(withSize: 16)).foregroundStyle(AppColors.darkBlue.opacity(0.7))
                    }
                }
                HStack {
                    Button(action: {
                        close()
                    }, label: {
                        Text("Cancel")
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
                    NavigationLink {
                        GameInfoView()
                    } label: {
                        Text("Start playing")
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
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(AppColors.white)
            .clipShape(RoundedRectangle(cornerRadius: 20.0))
            .shadow(radius: 20)
            .padding(30)
            .offset(x: 0, y: offset)
            .onAppear {
                withAnimation(.spring) {
                    offset = 0
                }
            }
        }
        .ignoresSafeArea()
    }
    
    func close() {
        withAnimation(.spring) {
            offset = 1000
            isActive = false
        }
    }
    
}

#Preview {
    GameDialogView(isActive: .constant(true) ,title: "Name of the game", players: "2-3", time: "30 min", image: "imag")
}
