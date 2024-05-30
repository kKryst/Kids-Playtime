//
//  GameAlertView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 18/01/2024.
//

import SwiftUI

struct GameDialogView: View {
    
    let game: Game
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
                AsyncImage(url: URL(string: game.imageURL)) { phase in
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
                    Text(game.title).font(AppFonts.amikoSemiBold(withSize: 24)).foregroundStyle(AppColors.darkBlue.opacity(0.9))
                    Spacer()
                }
                HStack (spacing: 30){
                    VStack {
                        Text("players").font(AppFonts.amikoSemiBold(withSize: 18)).foregroundStyle(AppColors.darkBlue.opacity(0.9))
                        Text("\(game.minNumberOfPlayers)-\(game.maxNumberOfPlayers)").font(AppFonts.amikoRegular(withSize: 16)).foregroundStyle(AppColors.darkBlue.opacity(0.7))
                    }
                    VStack {
                        Text("est. time").font(AppFonts.amikoSemiBold(withSize: 18)).foregroundStyle(AppColors.darkBlue)
                        Text("\(game.estimatedTime)").font(AppFonts.amikoRegular(withSize: 16)).foregroundStyle(AppColors.darkBlue.opacity(0.7))
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
                        GameInfoView(game: game) // navigate to GameInfoView
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
    GameDialogView(game: Game(title: "Test 1", imageURL: "https://cdn.britannica.com/84/73184-050-05ED59CB/Sunflower-field-Fargo-North-Dakota.jpg", minNumberOfPlayers: 5, maxNumberOfPlayers: 30, longDescription: "This is a long desc ", estimatedTime: 30), isActive: .constant(true))
}
