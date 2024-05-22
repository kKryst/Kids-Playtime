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

    
    func readValue(completion: @escaping (String?) -> Void) {
        let child = database.child("value")
        
        child.observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? String
            completion(value)
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
    
    func addGame() {
        
        #warning("TODO: zamienić to na obiekt i wprowadzić kilka takich do bazy danych, następnie swtorzyc metode do fetchowania i podpiac pod liste na GameCards")
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
}
