//
//  User.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 24/05/2024.
//

import Foundation

struct User {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
