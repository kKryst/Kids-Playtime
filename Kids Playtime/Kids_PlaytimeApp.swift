//
//  Kids_PlaytimeApp.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 14/01/2024.
//

import SwiftUI

@main
struct Kids_PlaytimeApp: App {
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var viewRouter = ViewRouter()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(viewRouter)
                .preferredColorScheme(isDarkMode ? .dark : .light)
            
        }
    }
}
