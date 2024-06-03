//
//  Game.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 20/05/2024.
//

import Foundation

struct Game: Codable {
    let title: String
    let imageURL: String
    let minNumberOfPlayers: Int
    let maxNumberOfPlayers: Int
    let longDescription: String
    let estimatedTime: Int
    var rates: [GameRate]? = nil
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "title": title,
            "imageURL": imageURL,
            "minNumberOfPlayers": minNumberOfPlayers,
            "maxNumberOfPlayers": maxNumberOfPlayers,
            "longDescription": longDescription,
            "estimatedTime": estimatedTime
        ]
        
        if let rates = rates {
            dict["rates"] = rates.map { $0.toDictionary() }
        }
        
        return dict
    }
}

