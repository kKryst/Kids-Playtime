//
//  Kids_PlaytimeApp.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 14/01/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseDatabase
import FirebaseDatabaseSwift
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct Kids_PlaytimeApp: App {
    
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var networkMonitor = NetworkManager()
//    @StateObject var databaseManager = DatabaseManager()
//    var databaseManager = DatabaseManager()
    
    @StateObject var viewRouter = ViewRouter()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(viewRouter)
                .environmentObject(networkMonitor)
//                .environmentObject(databaseManager)
                .preferredColorScheme(isDarkMode ? .dark : .light)
            
        }
    }
}
