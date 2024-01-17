//
//  HomeView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 14/01/2024.
//

import SwiftUI

struct HomeView: View {
    
    @State private var tabSelection = 2
    
    var body: some View {
        TabView (selection: $tabSelection) {
            UserHomeView()
                .tag(1)
                .toolbarBackground(.hidden, for: .tabBar)
            DiscoverView()
                .toolbarBackground(.hidden, for: .tabBar)
                .tag(2)
            SettingsView()
                .tag(3)
                .toolbarBackground(.hidden, for: .tabBar)
        }
       
        .overlay(alignment: .bottom) {
            CustomTabView(tabSelection: $tabSelection)
                .offset(y: 20)
        }
    }
}

#Preview {
    HomeView()
}
