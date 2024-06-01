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
    
    private var database = Database.database(url: Constants.databaseUrl).reference()
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
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

    
    func readValue(completion: @escaping (String?) -> Void) {
        let child = database.child("value")
        
        child.observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? String
            completion(value)
        }
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
            database.child("games").observeSingleEvent(of: .value) { snapshot in
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
        let firstGame: [[String: Any]] = [[
            "date" : "20240520130855",
            "title": "Test game 3",
            "imageURL" : "https://picsum.photos/id/237/200/300",
            "minNumberOfPlayers" : 4,
            "maxNumberOfPlayers": 8,
            "longDescription": "This is a long desc for game 3 This is a long desc for game 3 This is a long desc for game 1 This is a long desc for game 1 This is a long desc for game 1 This is a long desc for game 1 This is a long desc for game 1 ",
            "estimatedTime": 90,
            
        ]]
        database.child("games").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            if var  games = snapshot.value as? [[String: Any]] {
                games.append(contentsOf: firstGame)
                self?.database.child("games").setValue(games)
            }
        })
    }
    
    func fetchFirstGame() {
        database.child("games").observeSingleEvent(of: .value) { snapshot in
            let games = snapshot.value as? [[String : Any]]
            print(games)
        }
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


