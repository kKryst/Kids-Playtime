//
//  DiscoverViewModel.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 12/02/2024.
//

import Foundation
import SwiftUI
import FirebaseDatabase
import FirebaseDatabaseSwift

extension DiscoverView {
    
    class ViewModel: ObservableObject {
        
        @Published var isGameDialogActive = false
        @Published var scale: CGFloat = 1.0
        @Published var isWheelSpinning = false
        @Published var games = ["🤫", "🤐", "🤐", "🤐", "🤐", "🤐"]
        @Published var valueFromFirebase: String? = nil
        
        
        func readValue() {
            // if we have this value cached
            if let safeValue = UserDefaults.standard.value(forKey: "value") as? String {
                self.valueFromFirebase = safeValue
            // fetch it from the Database
            } else {
                DatabaseManager.shared.readValue { [weak self] value in
                    DispatchQueue.main.async {
                        self?.valueFromFirebase = value
                        UserDefaults.standard.set(value, forKey: "value")
                    }
                }
            }
        }
    }
}
