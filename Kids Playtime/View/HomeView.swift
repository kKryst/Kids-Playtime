//
//  HomeView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 14/01/2024.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var tabSelection = 2 //handles currently selected View
    @State private var tabViewOffset: CGFloat = 20
    
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
                .offset(y: tabViewOffset)
        }
        // change the tabView's offset (hide / unhinde) depending on the EnvObj value 
        .onChange(of: viewRouter.shouldDisplayTabView) { newValue in
            if newValue {
                withAnimation(.spring) {
                    tabViewOffset = 20
                }
            } else {
                withAnimation(.spring) {
                    tabViewOffset = 500
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(ViewRouter())
}
