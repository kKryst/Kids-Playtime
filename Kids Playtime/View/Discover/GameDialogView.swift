//
//  GameAlertView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 18/01/2024.
//

import SwiftUI

struct GameDialogView: View {
    
    let gameCard: GameCard
    @State private var offset: CGFloat = 1000
    @State private var isImageVisible: Bool = false
    @Binding var isActive: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .onTapGesture {
                    close() // allows user to hide this dialog whenever he taps outside the view
                }
            VStack (spacing: 10) {
                AsyncImage(url: URL(string: gameCard.imageUrl)) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else if phase.error != nil {
                        ProgressView()
                    } else {
                        ProgressView()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 17.0))
                .padding(8)
                .frame(width: 200, height: 200)
                .opacity(isImageVisible ? 1.0 : 0.0)  // Control visibility based on state
                .offset(y: offset)
                .onAppear {
                    withAnimation(.easeOut(duration: 1.0)) {
                        offset = 0  // Animate offset to 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        isImageVisible = true  // Make the image visible after the offset animation
                    }
                }
                HStack {
                    Spacer()
                    Text(gameCard.nameOfTheGame).font(AppFonts.amikoSemiBold(withSize: 24)).foregroundStyle(AppColors.darkBlue.opacity(0.9))
                    Spacer()
                }
                HStack (spacing: 30){
                    VStack {
                        Text("players").font(AppFonts.amikoSemiBold(withSize: 18)).foregroundStyle(AppColors.darkBlue.opacity(0.9))
                        Text("\(gameCard.minNumberOfPlayers)-\(gameCard.maxNumberOfPlayers)").font(AppFonts.amikoRegular(withSize: 16)).foregroundStyle(AppColors.darkBlue.opacity(0.7))
                    }
                    VStack {
                        Text("est. time").font(AppFonts.amikoSemiBold(withSize: 18)).foregroundStyle(AppColors.darkBlue)
                        Text("\(gameCard.estimatedTime)").font(AppFonts.amikoRegular(withSize: 16)).foregroundStyle(AppColors.darkBlue.opacity(0.7))
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
                        GameInfoView(gameDetails: GameDetails(gameCard: gameCard, gameDescription: "This is a long description This is a long description This is a long description This is a long description This is a long description This is a long description This is a long description This is a long description")) // navigate to GameInfoView
                            .navigationBarBackButtonHidden()
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
            isActive = false
            offset = 1000
        }
    }
}

#Preview {
    GameDialogView(gameCard: GameCard(nameOfTheGame: "Test 1", minNumberOfPlayers: 3, maxNumberOfPlayers: 5, estimatedTime: 30, imageUrl: "https://cdn.britannica.com/84/73184-050-05ED59CB/Sunflower-field-Fargo-North-Dakota.jpg"), isActive: .constant(true))
}
