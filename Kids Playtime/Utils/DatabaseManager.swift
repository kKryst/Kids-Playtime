//
//  DatabaseManager.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 12/02/2024.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift


/// database connection class Singleton
public class DatabaseManager: ObservableObject {
    
    static let shared = DatabaseManager() // Singleton instance
    
    private init() {}
    
    private var database = Database.database(url: Constants.databaseUrl).reference()
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    func addGameRate(for email: String, title: String, rate: GameRate) {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        // Query the specific game by title
        database.child("games").queryOrdered(byChild: "title").queryEqual(toValue: title).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else {
                return
            }
            
            if !snapshot.exists() {
                print("Game with title \(title) not found.")
                return
            }
            
            if let gameSnapshot = snapshot.children.allObjects.first as? DataSnapshot,
               var gameDictionary = gameSnapshot.value as? [String: Any] {
                // Create a game object from the snapshot dictionary
                guard let jsonData = try? JSONSerialization.data(withJSONObject: gameDictionary),
                      var game = try? JSONDecoder().decode(Game.self, from: jsonData) else {
                    print("Failed to decode game")
                    return
                }
                
                // Add rate to the game
                var existingRates = game.rates ?? []
                existingRates.append(rate)
                game.rates = existingRates
                
                // Update the game in the database
                gameDictionary = game.toDictionary()
                self.database.child("games").child(gameSnapshot.key).setValue(gameDictionary) { error, _ in
                    if let error = error {
                        print("Failed to update game: \(error)")
                        return
                    } else {
                        print("Successfully updated game with new rate.")
                    }
                }
            } else {
                print("Game with title \(title) not found.")
            }
        }
        
        // Update user's rated games only if the title is not already added
        database.child(safeEmail).child("ratedGames").observeSingleEvent(of: .value) { snapshot in
            var ratedGamesCollection = snapshot.value as? [[String: Any]] ?? []
            
            // Check if the title already exists
            let titleExists = ratedGamesCollection.contains { $0["title"] as? String == title }
            
            if !titleExists {
                // Append to ratedGames dictionary
                let newElement = [
                    "title": title
                ]
                ratedGamesCollection.append(newElement)
                
                self.database.child(safeEmail).child("ratedGames").setValue(ratedGamesCollection) { error, _ in
                    if let error = error {
                        print("Failed to update ratedGames: \(error)")
                    } else {
                        print("Successfully updated ratedGames with new title.")
                    }
                }
            } else {
                print("Title \(title) already exists in ratedGames.")
            }
        }
    }

    
    func addGamesPlayed(for email: String) {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let gamesPlayedRef = database.child(safeEmail).child("gamesPlayed")
        gamesPlayedRef.observeSingleEvent(of: .value) { snapshot in
            if let gamesPlayed = snapshot.value as? Int {
                let tempGamesPlayed = gamesPlayed + 1
                gamesPlayedRef.setValue(tempGamesPlayed)
            } else {
                gamesPlayedRef.setValue(1)
            }
        }
    }
    
    func getGamesPlayed(for email: String, completion: @escaping (Int) -> Void) {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let gamesPlayedRef = database.child(safeEmail).child("gamesPlayed")
        
        gamesPlayedRef.observeSingleEvent(of: .value) { snapshot in
            guard let gamesPlayed = snapshot.value as? Int else {
                completion(0)
                return
            }
            
            completion(gamesPlayed)
        }
    }
    
    func addTimePlayed(for email: String, time: Double) {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let timePlayedRef = database.child(safeEmail).child("gamesPlayed")
        
        timePlayedRef.observeSingleEvent(of: .value) { snapshot in
            if let timeSpend = snapshot.value as? Double {
                //value already exsists. Add to it
                let tempTimeSpend = timeSpend + time
                timePlayedRef.setValue(tempTimeSpend)
            } else {
                timePlayedRef.setValue(time)
            }
        }
    }
    
    func getTimePlayed(for email: String, completion: @escaping (Double) -> Void) {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        database.child(safeEmail).child("timePlayed").observeSingleEvent(of: .value) { snapshot in
            guard let time = snapshot.value as? Double else {
                completion(0.0)
                return
            }
            
            completion(time)
        }
    }
    
     func isGameAlreadyAddedToFavorites(email: String, title: String, completion: @escaping (Bool) -> Void) {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        database.child(safeEmail).child("savedGames").observeSingleEvent(of: .value, with: { snapshot in
            guard let savedGamesArray = snapshot.value as? [[String: Any]] else {
                completion(false)
                return
            }
            
            for game in savedGamesArray {
                if let savedGameTitle = game["title"] as? String, savedGameTitle == title {
                    completion(true)
                    return
                }
            }
            // game does not exist in this user's saved games list
            completion(false)
        })
    }
    
    func removeGameFromFavorites(email: String, title: String, completion: @escaping (Result<Any, Error>) -> Void) {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        database.child(safeEmail).child("savedGames").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            if var savedGamesCollection = snapshot.value as? [[String: Any]] {
                // Filter out the game with the specified title
                savedGamesCollection.removeAll { $0["title"] as? String == title }
                
                // Update the database with the filtered list
                strongSelf.database.child(safeEmail).child("savedGames").setValue(savedGamesCollection, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        completion(.failure(DatabaseError.failedToFetch))
                        return
                    }
                    completion(.success("success"))
                })
            } else {
                // If there are no saved games, return success as there's nothing to remove
                completion(.success("success"))
            }
        })
    }

    
    func addGameToFavoutires(for email: String, title: String, completion: @escaping (Result<Any, Error>) -> Void) {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        database.child(safeEmail).child("savedGames").observeSingleEvent(of: .value, with: { [weak self] snapshot in
           guard let strongSelf = self else {
                return
            }
            if var savedGamesCollection = snapshot.value as? [[String: Any]] {
                // append to savedGames dictionary
                let newElement = [
                    "title": title
                ]
                savedGamesCollection.append(newElement)
                
                strongSelf.database.child(safeEmail).child("savedGames").setValue(savedGamesCollection, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        completion(.failure(DatabaseError.failedToFetch))
                        return
                    }
                    completion(.success("success"))
                })
            }
            else {
                // create that array
                let newSavedGamesCollection: [[String: String]] = [
                    [
                        "title": title
                    ]
                ]
                strongSelf.database.child(safeEmail).child("savedGames").setValue(newSavedGamesCollection, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        completion(.failure(DatabaseError.failedToFetch))
                        return
                    }
                    completion(.success("success"))
                })
            }
        })
    }

    func fetchSavedGames(for email: String, completion: @escaping ([Game]?) -> Void) {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        database.child(safeEmail).child("savedGames").observeSingleEvent(of: .value) { snapshot in
            guard let snapshotArray = snapshot.value as? [[String: Any]] else {
                completion(nil)
                return
            }
            
            var gameTitles: [String] = []
            for value in snapshotArray {
                if let title = value["title"] as? String {
                    gameTitles.append(title)
                }
            }
            
            DatabaseManager.shared.fetchAllGames { allGames in
                guard let allGames = allGames else {
                    completion(nil)
                    return
                }
                
                let savedGames = allGames.filter { game in
                    gameTitles.contains(game.title)
                }
                
                completion(savedGames)
            }
        }
    }

    
    func fetchAllGames(completion: @escaping ([Game]?) -> Void) {
        database.child("games").queryLimited(toFirst: 20).observeSingleEvent(of: .value) { snapshot in
                guard let snapshotArray = snapshot.value as? [[String: Any]] else {
                    completion(nil)
                    return
                }
                do {
                    let data = try JSONSerialization.data(withJSONObject: snapshotArray, options: [])
                    let games = try JSONDecoder().decode([Game].self, from: data)
                    completion(games)
                } catch {
                    print("Failed to decode games: \(error)")
                    completion(nil)
                }
            }
        }
    
    /// Checks if user exists for given email
    /// Parameters
    /// - `email`:              Target email to be checked
    /// - `completion`:   Async closure to return with result
    public func userExists(with email: String,
                           completion: @escaping ((Bool) -> Void)) {
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let usersArray = snapshot.value as? [[String: Any]] else {
                completion(false)
                return
            }
            
            for user in usersArray {
                if let userEmail = user["email"] as? String, userEmail == safeEmail {
                    completion(true)
                    return
                }
            }
            
            // user does not exist
            completion(false)
        })
        
    }
    
    func getDataFor(email: String, completion: @escaping (Result<Any, Error>) -> Void) {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let usersArray = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            for user in usersArray {
                if let userEmail = user["email"] as? String, userEmail == safeEmail {
                    completion(.success(user))
                    return
                }
            }
        })
    }
    
    
    
    func insertUser(with user: User, completion: @escaping (Bool) -> Void) {
        
        // check if given user exists
        userExists(with: user.emailAddress) { [weak self] exists in
            guard !exists else {
                return
            }
            
            // create a strong referencec
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.database.child(user.safeEmail).setValue([
                "first_name": user.firstName,
                "last_name": user.lastName
            ]) { error, _ in
                guard error == nil else {
                    return
                }
                strongSelf.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                    if var usersCollection = snapshot.value as? [[String: String]] {
                        // append to user dictionary
                        let newElement = [
                            "name": user.firstName + " " + user.lastName,
                            "email": DatabaseManager.safeEmail(emailAddress: user.emailAddress)
                        ]
                        usersCollection.append(newElement)
                        
                        strongSelf.database.child("users").setValue(usersCollection, withCompletionBlock: { error, _ in
                            guard error == nil else {
                                completion(false)
                                return
                            }
                            
                            completion(true)
                        })
                    }
                    else {
                        // create that array
                        let newCollection: [[String: String]] = [
                            [
                                "name": user.firstName + " " + user.lastName,
                                "email": DatabaseManager.safeEmail(emailAddress: user.emailAddress)
                            ]
                        ]
                        strongSelf.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                            guard error == nil else {
                                completion(false)
                                return
                            }
                            
                            completion(true)
                        })
                    }
                })
            }
        }
    }

    
    func addGame() {
        let game: [[String: Any]] = [[
            "date" : "20240520130855",
            "title": "Test game",
            "imageURL" : "https://picsum.photos/id/237/200/300",
            "minNumberOfPlayers" : 4,
            "maxNumberOfPlayers": 8,
            "longDescription": "This is a long desc for game This is a long desc for game 3 This is a long desc for game 1 This is a long desc for game 1 This is a long desc for game 1 This is a long desc for game 1 This is a long desc for game 1 ",
            "estimatedTime": 90,
            
        ]]
        database.child("games").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            if var  games = snapshot.value as? [[String: Any]] {
                games.append(contentsOf: game)
                self?.database.child("games").setValue(games)
            }
        })
    }
    
    public enum DatabaseError: Error {
        case failedToFetch

        public var localizedDescription: String {
            switch self {
            case .failedToFetch:
                return "This means blah failed"
            }
        }
    }
    
}


