//
//  HomeView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 14/01/2024.
//

import SwiftUI

struct HomeView: View {
    
    @State private var tabSelection = 1
    
    var body: some View {
        TabView (selection: $tabSelection) {
            UserHomeView()
                .navigationBarBackButtonHidden()
                .tag(1)
            DiscoverView()
                .tag(2)
            SettingsView()
                .navigationBarBackButtonHidden()
                .tag(3)
        }
        .overlay(alignment: .bottom) {
            CustomTabView(tabSelection: $tabSelection)
                .offset(y: 10)
        }
    }
        
}

#Preview {
    HomeView()
}
