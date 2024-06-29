//
//  GameInfoView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 23/01/2024.
//

import SwiftUI
import FirebaseAuth

struct GameInfoView: View {
    
    let game: Game
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var networkManager: NetworkManager
    
    @State private var noInternetAlert = false
    @State private var isDialogPresenting = false
    @State private var shouldPresentOpinionSheet = false
    @State var isFavourite = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background full-size image with blur effect
            AsyncImage(url: URL(string: game.imageURL)) { image in
                image.resizable()
                image.aspectRatio(contentMode: .fill)
            } placeholder: {
                AppColors.white
            }
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
                        toggleFavourite()
                    }, label: {
                        HStack {
                            Image(systemName: isFavourite ? "heart.fill" : "heart")
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
                        .task {
                            if Auth.auth().currentUser != nil {
                                isGameFavourite { result in
                                    isFavourite = result
                                }
                            }
                        }
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
                .task {
                    
                }
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
        .alert(
            "Could not save this game. Please check your Internet connection.",
            isPresented: $noInternetAlert
        ) {}
            .sheet(isPresented: $shouldPresentOpinionSheet, content: {
                GameOpinionView(gameTitle: game.title)
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
                NotificationManager.shared.removeNotificationFromQueue()
                viewRouter.shouldDisplayTabView = true
            })
        
    }
    
    func isGameFavourite(completion: @escaping (Bool) -> Void) {
        // Get user's email
        guard let email = UserDefaults.standard.value(forKey: "userEmail") as? String else {
            completion(false) // User is not logged in so game is not fav
            return
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        DatabaseManager.shared.isGameAlreadyAddedToFavorites(email: safeEmail, title: game.title) { result in
            completion(result)
        }
    }
    
    func toggleFavourite() {
        
        guard networkManager.isConnected else {
            noInternetAlert = true
            return
        }
        
        guard let email = UserDefaults.standard.value(forKey: "userEmail") as? String else {
            return // user is not logged in so game is not fav
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        isGameFavourite { isFavorite in
            if isFavorite {
                DatabaseManager.shared.removeGameFromFavorites(email: safeEmail, title: game.title) { result in
                    switch result {
                    case .success:
                        print("succesfully removed game from favorites")
                        isFavourite = false
                    case .failure:
                        print("failed to remove game from favorites")
                    }
                }
            } else {
                DatabaseManager.shared.addGameToFavoutires(for: safeEmail, title: game.title) { result in
                    switch result {
                    case .success:
                        print("Succesfully added game to favourites")
                        isFavourite = true
                    case .failure:
                        print("Failed to add game to favorites")
                    }
                }
            }
        }
    }
}

#Preview {
    GameInfoView(game: Game(title: "Test game 1", imageURL: "", minNumberOfPlayers: 3, maxNumberOfPlayers: 6, longDescription: "This is a long desscription", estimatedTime: 40)).environmentObject({ () -> ViewRouter in
        let envObj = ViewRouter()
        envObj.shouldDisplayTabView = false
        return envObj
    }() )
}
