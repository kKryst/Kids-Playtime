//
//  HomeView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 14/01/2024.
//

import SwiftUI

struct HomeView: View {
    
    @State private var tabSelection = 2 //handles currently selected View
    
    var body: some View {
        // tab bar destinations. Each has a hidden background for
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
       
        .overlay(alignment: .bottom) { // overlays this view with currently selected TabItem
            CustomTabView(tabSelection: $tabSelection)
                .offset(y: 20)
        }
    }
}

#Preview {
    HomeView()
}
