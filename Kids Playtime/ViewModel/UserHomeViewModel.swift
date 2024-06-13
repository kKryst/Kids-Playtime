//
//  UserHomeViewModel.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 08/02/2024.
//

import Foundation
import SwiftUI
import FirebaseAuth

extension UserHomeView {

    class ViewModel: ObservableObject {
        
        @Published var isUserLoggedIn: Bool = Auth.auth().currentUser != nil
        @Published var currentlyLoggedInUser = Auth.auth().currentUser?.email
        @Published var userName = "User"
        @Published var minutesPlayed = 0
        @Published var gamesPlayed = 0
        @Published var isGameDialogActive = false
        @Published var games: [Game] = []
        @Published var currentlySelectedGame: Game? = nil
        
        @Published var userProfilePictureURL: URL? = nil
        @Published var currentlyLoggedInUserEmail: String?
        
        private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
        
        init() {
            self.authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
                self?.isUserLoggedIn = user != nil
            }
        }
        
        deinit {
                if let handle = authStateDidChangeListenerHandle {
                    Auth.auth().removeStateDidChangeListener(handle)
                }
            }
        
        func getUserName() {
            if let cachedUserName = UserDefaults.standard.value(forKey: "name") as? String {
                userName = cachedUserName
            } else if var userNameFromAuthProvider = Auth.auth().currentUser?.displayName {
                userNameFromAuthProvider =  userNameFromAuthProvider.split(separator: " ").first.map(String.init) ?? userNameFromAuthProvider
                userName = userNameFromAuthProvider
            } else {
                userName = "User"
            }
        }
        
        func getTimePlayed() {
            guard let userEmail = UserDefaults.standard.value(forKey: "userEmail") as? String else {
                return
            }
            DatabaseManager.shared.getTimePlayed(for: userEmail) { [weak self] value in
                if value != 0.0 {
                    self?.minutesPlayed = Int(value)
                }
            }
        }
        
        func getGamesPlayed() {
            guard let userEmail = UserDefaults.standard.value(forKey: "userEmail") as? String else {
                return
            }
            
            DatabaseManager.shared.getGamesPlayed(for: userEmail) { [weak self] value in
                if value != 0 {
                    self?.gamesPlayed = value
                }
            }
        }
        
        func fetchSavedGames() {
            guard let userEmail = UserDefaults.standard.value(forKey: "userEmail") as? String else {
                return
            }
            let safeEmail = DatabaseManager.safeEmail(emailAddress: userEmail)
            DatabaseManager.shared.fetchSavedGames(for: safeEmail) { [weak self] games in
                if let games {
                    var modifiedGames: [Game] = []
                    games.forEach { game in
                        let modifiedImageURL = game.imageURL.replacingOccurrences(of: "!", with: "/")
                                                            .replacingOccurrences(of: "_", with: ".")
                        let modifiedGame = Game(title: game.title, imageURL: modifiedImageURL, minNumberOfPlayers: game.minNumberOfPlayers, maxNumberOfPlayers: game.maxNumberOfPlayers, longDescription: game.longDescription, estimatedTime: game.estimatedTime) // Add all necessary properties here
                        modifiedGames.append(modifiedGame)
                    }
                    self?.games = modifiedGames
                }
            }
        }
        
        func getUserProfilePictureURL() {
            /*
             /images/emailaddress123-gmail-com_profile_picture.png
             */
            if let loggedInUserEmail = UserDefaults.standard.value(forKey: "userEmail") as? String {
                let pathToImage = StorageManager.getPathToImage(for: loggedInUserEmail)
                StorageManager.shared.downloadURL(for: pathToImage) { [weak self] result in
                    switch result {
                    case .success(let url):
                        self?.userProfilePictureURL = url
                    case .failure(let error):
                        print("failed to get img url: \(error)")
                    }
                }
            } else {
                print("No userEmail in cache")
            }
        }
    }
}
