//
//  GameAlertView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 18/01/2024.
//

import SwiftUI
import FirebaseAuth


// animations disabled due to problem with gamecardView not appearing when user disables card when the animation is still running
struct GameDialogView: View {
    let game: Game
    @State private var offset: CGFloat = 1000
    @State private var isImageVisible: Bool = false
    @State var isFavourite = false
    @Binding var isActive: Bool
    
    @State var shouldDisplayUserNotLoggedInAlert = false
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
//                .opacity(isImageVisible ? 1.0 : 0.0)  // Control visibility based on state
//                .onAppear {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
//                        isImageVisible = true  // Make the image visible after the offset animation
//                    }
//                }
                HStack {
                    Spacer()
                    Text(game.title).font(AppFonts.amikoSemiBold(withSize: 24)).foregroundStyle(AppColors.darkBlue.opacity(0.9))
                    Spacer()
                }
                HStack {
                    ScrollView(showsIndicators: true) {
                        Text(game.longDescription)
                            .font(AppFonts.amikoRegular(withSize: 16))
                            .foregroundStyle(AppColors.darkBlue.opacity(0.7))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 150)
                HStack (spacing: 30){
                    VStack {
                        Text("players")
                            .font(AppFonts.amikoSemiBold(withSize: 18))
                            .foregroundStyle(AppColors.darkBlue.opacity(0.9))
                        Text("\(game.minNumberOfPlayers)-\(game.maxNumberOfPlayers)")
                            .font(AppFonts.amikoRegular(withSize: 16))
                            .foregroundStyle(AppColors.darkBlue.opacity(0.7))
                    }
                    VStack {
                        Text("est. time").font(AppFonts.amikoSemiBold(withSize: 18)).foregroundStyle(AppColors.darkBlue)
                        Text("\(game.estimatedTime) min").font(AppFonts.amikoRegular(withSize: 16)).foregroundStyle(AppColors.darkBlue.opacity(0.7))
                    }
                }
                HStack {
                    Button(action: {
                        if Auth.auth().currentUser != nil {
                            toggleFavourite()
                        }  else {
                            shouldDisplayUserNotLoggedInAlert = true
                        }
                        
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
                    NavigationLink {
                        GameInfoView(game: game) // navigate to GameInfoView
                            .navigationBarBackButtonHidden()
                            .onAppear {
                                NotificationManager.shared.askForPermissionToSendNotifications()
                                NotificationManager.shared.createNotification(gameTitle: game.title)
                            }
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
            .padding()
            .background(AppColors.white)
            .clipShape(RoundedRectangle(cornerRadius: 20.0))
            .shadow(radius: 20)
            .padding(30)
            .offset(x: 0, y: offset)
            .onAppear {
                resetOffset()
            }
            .onChange(of: isActive) { newValue in
                if newValue {
                    resetOffset()
                }
            }
        }
        .ignoresSafeArea()
        .alert("Log in to save games", isPresented: $shouldDisplayUserNotLoggedInAlert) {
            Button("Ok", action: {
                shouldDisplayUserNotLoggedInAlert = false
            })
        }

    }
    
    private func resetOffset(){
//        withAnimation(.spring) {
            offset = -30
//        }
    }
    
    func close() {
//        withAnimation(.spring) {
            isActive = false
            offset = 1000
//        }
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
    GameDialogView(game: Game(title: "Test 1", imageURL: "https://cdn.britannica.com/84/73184-050-05ED59CB/Sunflower-field-Fargo-North-Dakota.jpg", minNumberOfPlayers: 5, maxNumberOfPlayers: 30, longDescription: "This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc This is a long desc ", estimatedTime: 30), isActive: .constant(true))
}
