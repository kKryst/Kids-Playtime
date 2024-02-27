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
    
    private var ref = Database.database(url: K.databaseUrl).reference()

    
    func readValue(completion: @escaping (String?) -> Void) {
        let child = ref.child("KeyA")
        
        child.observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? String
            completion(value)
        }
    }
}
